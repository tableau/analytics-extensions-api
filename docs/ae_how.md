---
title: How it Works
layout: docs
---

In Tableau Desktop, [configure a connection](https://tableau.github.io/analytics-extensions-api/docs/ae_connect_desktop.html)  to an analytics extension that you create. You can pass data out and return it back in, as you are using a viz or creating a data source. You can do advanced analysis such as forecasting, classification, simulation, all from inside a Tableau visualization. The directness of the integration means that it's all dynamic. As people ask new questions and come up with new scenarios that they want to test or as new data comes in, they can see the latest results. Use Tableau Server to share dashboards or visualizations that call extensions code.

You communicate with external services from Tableau through table calculations called [SCRIPT/MODEL functions](https://help.tableau.com/current/pro/desktop/en-us/r_connection_manage.htm#script-functions-for-expressions) or through Table Extensions. 

The calculations are computed on the visual level of detail in the visualization where you're using them. The script calculations are: SCRIPT_REAL, SCRIPT_INT, SCRIPT_STR, and SCRIPT_BOOL. The model calculations are: MODEL_EXTENSION_REAL, MODEL_EXTENSION_INT, MODEL_EXTENSION_STR, and MODEL_EXTENSION_BOOL. They tell Tableau what data type to expect as a result from the analytics extension. Calculations allow you to write code or identify external functions in Tableau, pass data out, use it in the code or function in your analytics extension, and then return the results back. You can pass both aggregate dimensions and measures and parameters from Tableau into the script. For more information, refer to the blog post [Working with External Services in Tableau: Python, R, and MATLAB](https://www.tableau.com/about/blog/2018/8/working-external-services-tableau-tabpy-r-matlab-93351).

Table Extensions are accessed through the Data Source tab in Tableau. A Table Extension is an object type that can be dragged into the data model from most data sources. Table Extensions allow you pass a script to the analytics extension and optionally add one or multiple input tables from the current data source. The resulting table of data is returned to Tableau and functions like any other data. 
