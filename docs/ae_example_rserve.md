---
title: Example—RestRserve
layout: docs
---

Rserve is an R server that Tableau has long connected to at the transport layer (TCP). Rserve can now also be reached over HTTP through the Analytics Extensions API, which gives Rserve users the same capabilities that TabPy and other Analytics Extensions already have in Tableau. We recommend [RestRserve](https://restrserve.org) to serve Rserve over HTTP.

The R script below is a complete, working Analytics Extension server built on RestRserve. Edit the parts marked `Customize` (credentials, port, deployed models, and HTTPS); leave the parts marked `Contract` as-is. You can view or download the full file here: [analytics_extension_server.R]({{ site.baseurl }}/docs/rserve/analytics_extension_server.R) ([view on GitHub](https://github.com/tableau/analytics-extensions-api/blob/master/docs/rserve/analytics_extension_server.R)).

### Requirements and run

This example requires the **RestRserve** and **jsonlite** R packages. Install them, then start the server from a terminal (make sure the port is free first):

```bash
R -e "install.packages(c('RestRserve', 'jsonlite'), repos = 'https://cloud.r-project.org/')"
Rscript analytics_extension_server.R
```

### analytics_extension_server.R

```r
{% include_relative rserve/analytics_extension_server.R %}
```
