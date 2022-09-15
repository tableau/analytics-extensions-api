---
title: Query Endpoint
layout: docs
---

```POST /query/{function_name}```

Executes a predefined function (i.e. function_name) that is already stored on the analytics extension. It replaces named parameters with their provided values. The Query endpoint is designed as an alternative to the Evaluate endpoint so that the execution script does not need to be passed from Tableau (client side), and is instead managed and maintained on the analytics extension (server side).

The Query endpoint is used in conjunction with the MODEL_EXTENSION functions in a Tableau table calculation.

If you would like to only use the Query endpoint, you can inform the client that the Evaluate endpoint is disabled by adding the key-value pair `"evaluate_enabled": false` to the features property of the /info endpoint.

Username and password values that have been configured in Tableau are passed to the Analytics Extension using the HTTP headers of calls to the /query/{function_name} method.

The POST body is a JSON dictionary with one element:

- **data**: contains the parameter values passed to the code. These values are key-value pairs, and the keys are user defined (i.e. do not following a specific convention like they do for the evaluate endpoint). These take dimensions and measures from Tableau and pass them to the analytics extension.

Curl Example: `curl -X POST http://localhost:9004/query/clustering -d '{"data": {"x": [6.35, 6.40, 6.65], "y": [1.95, 1.95, 2.05]}}'`

For more information, see [https://tableau.github.io/analytics-extensions-api/docs/ae_api_ref.html#post-query](https://tableau.github.io/analytics-extensions-api/docs/ae_api_ref.html#post-query).
