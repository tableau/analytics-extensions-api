---
title: Evaluate Endpoint
layout: docs
---

```POST /evaluate```

Executes a block of code, replacing named parameters with their provided values. The Evaluate endpoint is where all of the analysis using the service is done.

The POST body is a JSON dictionary with two elements:

- **data**: a value that contains the parameter values passed to the code. These values are key-value pairs, following a specific convention for key names (_arg1, _arg2, etc.). These take dimensions and measures from Tableau and pass them to the external service.
- **script**: a value that contains one or more lines of code or instructions for the analytics extension. Any references to the data or parameter names will be replaced by their values according to data. It defines the instructions about what the external service should execute. For example, a Python script, the name of a remote process or function, a script in another language, or it could be empty if the service just performs a single function.

Example: `curl -X POST http://localhost:9004/evaluate -d '{"data": {"arg_1":1,"arg_2":2}, "script": "return _arg1 + _arg2"}'`

For more information, see [https://github.com/tableau/TabPy/blob/master/docs/api-v1.md#httppost-evaluate](https://github.com/tableau/TabPy/blob/master/docs/api-v1.md#httppost-evaluate).
