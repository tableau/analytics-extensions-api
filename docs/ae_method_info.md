---
title: Info Endpoint
layout: docs
---

```GET /info```

Get static information about the server. This is used for Tableau to understand how the analytics extension is configured. It returns data about the service, such as whether authentication is required. It helps Tableau understand what's sitting on the other side and what Tableau should be passing.

Example: ```curl -X GET http://localhost:9004/info```

Response body:

```JSON
{
    "description": "",
    "creation_time": "0",
    "state_path": "e:\\dev\\server",
    "server_version": "0.4.1",
    "name": "Server",
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

For more information, see [https://tableau.github.io/analytics-extensions-api/docs/ae_api_ref.html#get-info](https://tableau.github.io/analytics-extensions-api/docs/ae_api_ref.html#get-info).
