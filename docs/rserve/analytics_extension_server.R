# Tableau Analytics Extension server (Rserve-by-HTTP via RestRserve).
# Serves the Analytics Extensions API so Rserve is reached over HTTP, not TCP.
# API: https://tableau.github.io/analytics-extensions-api
#
# Run:     Rscript analytics_extension_server.R
# Install: R -e "install.packages(c('RestRserve', 'jsonlite'))"
#
# Adapting this file: edit the parts marked "Customize". Leave the parts marked
# "Contract" as-is; Tableau relies on them to connect.

library(RestRserve)
library(jsonlite)

# Configuration ----------------------------------------------------------------
# Customize: set credentials (via env vars) and the listening port.
# Credentials come from the environment so they stay out of source control.
config <- list(
  user     = Sys.getenv("RSERVE_USER", unset = "---"),
  password = Sys.getenv("RSERVE_PASSWORD", unset = "---"),
  port     = as.integer(Sys.getenv("RSERVE_PORT", unset = "6005"))
)

logger <- Logger$new(level = "info", name = "analytics-extension")

# Authentication ---------------------------------------------------------------
# Customize: swap in your own auth check (or remove auth entirely).
authenticate <- function(user, password) {
  isTRUE(identical(user, config$user) && identical(password, config$password))
}

# Log the caller from the Authorization header, if present.
log_authenticated_user <- function(request) {
  header <- request$get_header("Authorization")
  if (is.null(header) || length(header) == 0L) {
    return(invisible(NULL))
  }
  encoded <- sub("Basic ", "", header, fixed = TRUE)
  user <- strsplit(rawToChar(base64_dec(encoded)), ":", fixed = TRUE)[[1L]][[1L]]
  logger$info(sprintf("Authenticated as [%s]", user))
}

auth_backend <- AuthBackendBasic$new(FUN = authenticate)
auth_middleware <- AuthMiddleware$new(
  auth_backend = auth_backend,
  routes       = c("/evaluate", "/query", "/endpoints"),
  match        = c("exact", "partial", "exact"),
  id           = "basic_auth"
)

# Contract: emit errors as JSON so Tableau parses them correctly
HTTPError$set_content_type("application/json")$set_encode(function(body) {
  toJSON(if (is.list(body)) body else list(message = body), auto_unbox = TRUE)
})

app <- Application$new(
  content_type = "application/json",
  middleware   = list(auth_middleware),
  logger       = logger
)

# /info and /: advertise API version and required auth. -----------------------
# Contract: Tableau reads this response shape to negotiate the connection.
# This endpoint is unauthenticated so Tableau can negotiate before sending
# credentials; the root path serves the same response for convenience.
serve_info <- function(request, response) {
  info <- list(
    versions = list(
      v1 = list(
        features = list(
          authentication = list(
            required = TRUE,
            methods = list("basic-auth" = NULL)
          )
        )
      )
    )
  )
  response$set_body(toJSON(info, auto_unbox = TRUE))
}

app$add_get(path = "/info", FUN = serve_info)
app$add_get(path = "/", FUN = serve_info)

# /evaluate: run a Tableau-supplied script against its data. -------------------
# Contract: Tableau requires this endpoint; keep the path and the {data, script}
# request / JSON-result response as-is.
app$add_post(
  path = "/evaluate",
  FUN = function(request, response) {
    log_authenticated_user(request)

    payload <- fromJSON(rawToChar(request$body))
    data    <- payload$data
    script  <- payload$script

    logger$info(sprintf(
      "Calling /evaluate\n  Data: %s\n  Script: %s",
      toJSON(data), toString(script)
    ))

    if (is.null(script) || !nzchar(toString(script))) {
      raise(HTTPError$bad_request(body = "Request is missing a 'script'."))
    }

    # Contract: Tableau sends args as "_argN"; scripts reference them as ".argN".
    arg_keys <- names(data)[startsWith(names(data), "_arg")]
    for (key in arg_keys) {
      new_key <- sub("^_arg", ".arg", key)
      data[[new_key]] <- data[[key]]
      data[[key]] <- NULL
    }

    env <- if (length(data)) list2env(data) else new.env()
    result <- tryCatch(
      eval(parse(text = script), envir = env),
      error = function(e) {
        raise(HTTPError$internal_server_error(body = list(
          message = "Error processing script",
          info    = conditionMessage(e)
        )))
      }
    )

    json_result <- toJSON(result, auto_unbox = TRUE)
    logger$info(sprintf("Result: %s", json_result))
    response$set_body(json_result)
  }
)

# /query/addone: example deployed model (adds one to input x). -----------------
# Customize: copy this block per model you deploy; keep the response envelope
# (response/version/model) as-is, since Tableau's Model Calculations expect it.
app$add_post(
  path = "/query/addone",
  FUN = function(request, response) {
    log_authenticated_user(request)

    x <- fromJSON(rawToChar(request$body))$data$x
    logger$info(sprintf("Calling /query/addone with x: %s", toJSON(x)))

    if (is.null(x) || length(x) == 0L) {
      raise(HTTPError$internal_server_error(
        body = "Model 'addone' is missing input parameter 'x'."
      ))
    }

    result <- x + 1L
    logger$info(sprintf("Result: %s", toJSON(result, auto_unbox = TRUE)))
    response$set_body(toJSON(
      list(response = result, version = 1L, model = "addone"),
      auto_unbox = TRUE
    ))
  }
)

# /endpoints: list deployed models and their metadata. ------------------------
# Contract: Tableau (and TabPy-compatible clients) read this to discover
# deployed models. The response is a JSON object keyed by model name; an empty
# object {} means nothing is deployed. Fields mirror TabPy's schema.
#
# Customize: add an entry here for each /query/<model> you deploy above. This is
# a static registry because models are hardcoded routes, not dynamically
# deployed at runtime.
deployed_models <- list(
  addone = list(
    description        = "Adds one to input x. MODEL_EXTENSION_INT('addone', 'x', SUM([Integer]))",
    docstring          = "-- no docstring found in query function --",
    creation_time      = 1733262111L,
    version            = 1L,
    dependencies       = list(),
    last_modified_time = 1780684416L,
    type               = "model",
    target             = NULL,
    is_public          = TRUE
  )
)

app$add_get(
  path = "/endpoints",
  FUN = function(request, response) {
    log_authenticated_user(request)
    # Emit {} (not []) when empty so the shape stays an object.
    body <- if (length(deployed_models)) {
      toJSON(deployed_models, auto_unbox = TRUE, null = "null")
    } else {
      "{}"
    }
    response$set_body(body)
  }
)

# Start the server -------------------------------------------------------------
backend <- BackendRserve$new()

# Plaintext HTTP.
backend$start(app, http_port = config$port)

# Customize (recommended for production): switch to HTTPS. Uncomment, set cert
# paths, and set http_port = -1 to disable plaintext.
# backend$start(
#   app,
#   http_port     = -1,
#   http.tls.port = config$port,
#   tls.key       = normalizePath("cert/server.key"),
#   tls.cert      = normalizePath("cert/server.cert")
# )
