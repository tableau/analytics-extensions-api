---
title: API Reference
layout: docs
---

**In this section**

* TOC
{:toc}

----

Use the Tableau Analytics Extensions REST API to extend Tableau  dynamically to include popular data science programming languages and external tools and platforms.

## API Version 1 (Implemented in Tableau 2020.1+)

### Tableau Implementation

The methods in this section are implemented in Tableau products as of version 2020.1. In Tableau Desktop, the 'Test Connection' button in the Analytics Extension connection dialogue will call the /info method to determine if authentication is required and test if the analytics extension can be connected to succesfully. When analytics extension functions execute in Tableau Desktop and Server they call the /info and the /evaluate methods to establish authentication and evaluate the code or function call.

### GET /info

Get static information about the server. This is used for Tableau to understand how the analytics extension is configured. It returns data about the service, such as whether authentication is required. It helps Tableau understand what’s sitting on the other side and what Tableau should be passing.

#### URL

```HTTP
/info
```

#### Method

```HTTP
GET
```

#### URL parameters

None.

#### Data Parameters

None.

#### Response

For a successful call:

- Status: 200
- Content:

  ```json
  {
      "description": "",
      "creation_time": "0",
      "state_path": "e:\\dev\\server\\server\\server",
      "server_version": "0.4.1",
      "name": "Server",
      "versions": {
          "v1": {
              "features": {}
          }
      }
  }
  ```

Response fields:

Property | Description
--- | ---
`description` | String that is hard coded in the `state.ini` file and can be edited there.
`creation_time` |  Creation time in seconds since 1970-01-01, hard coded in the `state.ini` file, where it can be edited.
`state_path` | State file path of the server.
`server_version` | The server version tag. Clients can use this information for compatibility checks.
`name` | The server instance name. Can be edited in `state.ini` file.
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

When authentication is enabled for v1 API `/info` call, the response contains the authentication feature parameter, e.g.:

  ```json
  {
      "description": "",
      "creation_time": "0",
      "state_path": "e:\\dev\\server\\server\\server",
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

v1 authentication specific features (see the example above):

Property | Description
--- | ---
`required` | Authentication is never optional for a client to use if it is in the features list. Both settings of true or false will result in a requirement for authentication.
`methods` | List of supported authentication methods with their properties.
`methods.basic-auth` | HTTP basic authentication. 


### POST /evaluate

Executes a block of code, replacing named parameters with their provided values. The Evaluate endpoint is where all of the analysis using the service is done.

The expected POST body is a JSON dictionary with two elements:

- **data**: a value that contains the parameter values passed to the code. These values are key-value pairs, following a specific convention for key names (_arg1, _arg2, etc.). These take dimensions and measures from Tableau and pass them to the analytics extension. When using the analytics extension with a Table Extension, the data element will contain just one key (_arg1) that represents the input table in object/dict format.
- **script**: a value that contains one or more lines of code or instructions for the analytics extension. Any references to the data or parameter names will be replaced by their values according to data. It defines the instructions about what the analytics extension should execute. For example, a Python script, the name of a remote process or function, a script in another language, or it could be empty if the service just performs a single function.

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

[
                4,
                1,
                8
]
```

When using **table calculations**, Tableau expects the /evaluate method to return either:
* exactly 1 value which is then copied to each row in the table behind a viz.
-or- 
* a collection of the same size as there are rows in the input data.

If a scalar value is returned, that value will be assigned to the calculated field in Tableau for each row in the field.

If an array response is returned, the number of elements in the array must exactly match the number of rows in the calculated field that the response will be assigned to. Usually, this is done by sending from Tableau an array with the right number of elements as an input parameter in the /evaluate request body. The Analytics Extension should then return an array of the same size as the input parameter.

Table Calculations Example:

```bash
curl -X POST http://localhost:9004/evaluate \
-d '{"data": {"_arg1": 1, "_arg2": 2}, "script": "return _arg1 + _arg2"}'
```

When using **Table Extensions**, Tableau expects the /evaluate method to return an object with a key-value pair for each column in the return table. The key is the column name, and the value is an array of data values.

Table Extension Example:

```bash
curl -X POST http://localhost:9004/evaluate \
-d '{"data": {"_arg1": {"Name": ["Bob", "Alice"], "Score": [1, 2]}, "script": "return _arg1"}'
```
