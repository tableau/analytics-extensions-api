---
title: API Reference
layout: docs
---

**In this section**

* TOC
{:toc}

----

Use the Tableau Analytics Extensions REST API to extend Tableau calculations dynamically to include popular data science programming languages and external tools and platforms.

## API Version 1
### GET /info

Get static information about the server. This is used for Tableau to understand how the analytics extension is configured. It returns data about the service, such as whether authentication is required. It helps Tableau understand what’s sitting on the other side and what Tableau should be passing.

### URL

```HTTP
/info
```

### Method

```HTTP
GET
```

### URL parameters

None.

### Data Parameters

None.

### Response

For a successful call:

- Status: 200
- Content:

  ```json
  {
      "description": "",
      "creation_time": "0",
      "state_path": "e:\\dev\\TabPy\\tabpy-server\\tabpy_server",
      "server_version": "0.4.1",
      "name": "TabPy Server",
      "versions": {
          "v1": {
              "features": {
                  "authentication": {
                      "required": true,
                      "methods": {
                          "basic-auth": {}
                      }
                  }
              }
          }
      }
  }
  ```

Response fields:

Property | Description
--- | ---
`description` | String that is hard coded in the `state.ini` file and can be edited there.
`creation_time` |  Creation time in seconds since 1970-01-01, hard coded in the `state.ini` file, where it can be edited.
`state_path` | State file path of the server (the value of the TABPY_STATE_PATH at the time the server was started).
`server_version` | TabPy Server version tag. Clients can use this information for compatibility checks.
`name` | TabPy server instance name. Can be edited in `state.ini` file.
`version` | Collection of API versions supported by the server. Each entry in the collection is an API version which has a corresponding list of properties.
`version.`*`<ver>`* | Set of properties for an API version.
`version.`*`<ver>.features`* | Set of an API's available features.
`version.`*`<ver>.features.<feature>`* | Set of a feature's properties. For specific details for a particular property meaning of a feature, check the documentation for the specific API version.
`version.`*`<ver>.features.<feature>.required`* | If true the feature is required to be used by client.

Example:

```bash
curl -X GET http://localhost:9004/info
```

### Authentication

When authentication is enabled for v1 API `/info` call, the response contains authentication feature parameters, e.g.:

  ```json
  {
      "description": "",
      "creation_time": "0",
      "state_path": "e:\\dev\\TabPy\\tabpy-server\\tabpy_server",
      "server_version": "0.4.1",
      "name": "TabPy Server",
      "versions": {
          "v1": {
              "features": {
                  "authentication": {
                      "required": true,
                      "methods": {
                          "basic-auth": {}
                      }
                  }
              }
          }
      }
  }
  ```

v1 authentication specific features (see the example above):

Property | Description
--- | ---
`required` | Authentication is never optional for a client to use if it is in the features list.
`methods` | List of supported authentication methods with their properties.
`methods.basic-auth` | TabPy requires basic access authentication. See [TabPy Server Configuration Instructions](server-config.md#authentication) for how to configure authentication.


### POST /evaluate

Executes a block of code, replacing named parameters with their provided values. The Evaluate endpoint is where all of the analysis using the service is done.

The expected POST body is a JSON dictionary with two elements:

- **data**: a value that contains the parameter values passed to the code. These values are key-value pairs, following a specific convention for key names (_arg1, _arg2, etc.). These take dimensions and measures from Tableau and pass them to the external service.
- **script**: a value that contains one or more lines of code or instructions for the analytics extension. Any references to the data or parameter names will be replaced by their values according to data. It defines the instructions about what the external service should execute. For example, a Python script, the name of a remote process or function, a script in another language, or it could be empty if the service just performs a single function.

Example request:

```HTTP
POST /evaluate HTTP/1.1
Host: localhost:9004
Accept: application/json

{"data": {"_arg1": 1, "_arg2": 2}, "script": "return _arg1+_arg2"}
```

Example response:

```HTTP
HTTP/1.1 200 OK
Content-Type: application/json

3
```

Using curl:

```bash
curl -X POST http://localhost:9004/evaluate \
-d '{"data": {"_arg1": 1, "_arg2": 2}, "script": "return _arg1 + _arg2"}'
```

It is possible to call a deployed function from within the code block through
the predefined function `tabpy.query`. This function works like the client
library's `query` method, and returns the corresponding data structure. The
function must first be deployed as an endpoint in the server.

The following example calls the endpoint `clustering`:

```HTTP
POST /evaluate HTTP/1.1
Host: example.com
Accept: application/json

{ "data":
  { "_arg1": [6.35, 6.40, 6.65, 8.60, 8.90, 9.00, 9.10],
    "_arg2": [1.95, 1.95, 2.05, 3.05, 3.05, 3.10, 3.15]
  },
  "script": "return tabpy.query('clustering', x=_arg1, y=_arg2)"}
```

The next example shows how to call `evaluate` from a terminal using curl. This
code queries the method `add` that was deployed in the section
[deploy-function](tabpy-tools.md#deploying-a-function):

```bash
curl -X POST http://localhost:9004/evaluate \
-d '{"data": {"_arg1":1, "_arg2":2},
     "script": "return tabpy.query(\"add\", x=_arg1, y=_arg2)[\"response\"]"}'
```


## Proposed

### GET /status

Gets runtime status of deployed endpoints. If no endpoints are deployed in
the server, the returned data is an empty JSON object.

Example request:

```HTTP
GET /status HTTP/1.1
Host: localhost:9004
Accept: application/json
```

Example response:

```HTTP
HTTP/1.1 200 OK
Content-Type: application/json

{"clustering": {
  "status": "LoadSuccessful",
  "last_error": null,
  "version": 1,
  "type": "model"},
 "add": {
  "status": "LoadSuccessful",
  "last_error": null,
  "version": 1,
  "type": "model"}
}
```

Using curl:

```bash
curl -X GET http://localhost:9004/status
```

### GET /endpoints

Gets a list of deployed endpoints and their static information. If no
endpoints are deployed in the server, the returned data is an empty JSON object.

Example request:

```HTTP
GET /endpoints HTTP/1.1
Host: localhost:9004
Accept: application/json
```

Example response:

```HTTP
HTTP/1.1 200 OK
Content-Type: application/json

{"clustering":
  {"description": "",
   "docstring": "-- no docstring found in query function --",
   "creation_time": 1469511182,
   "version": 1,
   "dependencies": [],
   "last_modified_time": 1469511182,
   "type": "model",
   "target": null},
"add": {
  "description": "",
  "docstring": "-- no docstring found in query function --",
  "creation_time": 1469505967,
  "version": 1,
  "dependencies": [],
  "last_modified_time": 1469505967,
  "type": "model",
  "target": null}
}
```

Using curl:

```bash
curl -X GET http://localhost:9004/endpoints
```

### GET /endpoints/:endpoint

Gets the description of a specific deployed endpoint. The endpoint must first
be deployed in the server.

Example request:

```HTTP
GET /endpoints/add HTTP/1.1
Host: localhost:9004
Accept: application/json
```

Example response:

```HTTP
HTTP/1.1 200 OK
Content-Type: application/json

{"description": "", "docstring": "-- no docstring found in query function --",
 "creation_time": 1469505967, "version": 1, "dependencies": [],
 "last_modified_time": 1469505967, "type": "model", "target": null}
```

Using curl:

```bash
curl -X GET http://localhost:9004/endpoints/add
```

### POST /query/:endpoint

Executes a function at the specified endpoint. The function must first be
deployed.

This interface expects a JSON body with a `data` key, specifying the values
for the function, according to its original definition. In the example below,
the function `clustering` was defined with a signature of two parameters `x`
and `y`, expecting arrays of numbers.

Example request:

```HTTP
POST /query/clustering HTTP/1.1
Host: localhost:9004
Accept: application/json

{"data": {
  "x": [6.35, 6.40, 6.65, 8.60, 8.90, 9.00, 9.10],
  "y": [1.95, 1.95, 2.05, 3.05, 3.05, 3.10, 3.15]}}
```

Example response:

```HTTP
HTTP/1.1 200 OK
Content-Type: application/json

{"model": "clustering", "version": 1, "response": [0, 0, 0, 1, 1, 1, 1],
 "uuid": "46d3df0e-acca-4560-88f1-67c5aedeb1c4"}
```

Using curl:

```bash
curl -X GET http://localhost:9004/query/clustering -d \
'{"data": {"x": [6.35, 6.40, 6.65, 8.60, 8.90, 9.00, 9.10],
           "y": [1.95, 1.95, 2.05, 3.05, 3.05, 3.10, 3.15]}}'
```
