---
title: Introduction
layout: docs
---

The Analytics Extensions API can be used to extend Tableau calculations to dynamically include popular data science programming languages and external tools and platforms. Use it to create integrations similar to Tableau’s integrations with TabPy and MATLAB. Analytics extensions can receive data from Tableau in real time and return it back after it has been scored, transformed, or augmented.

<div class="alert alert-info"><b>Note:</b> If you are looking for the Tableau Dashboard Extensions API, see the <a href="https://tableau.github.io/extensions-api/#" target="_blank">Tableau Dashboard Extensions API</a> documentation.
</div>

The Analytics Extensions API is based on the Python integration for Tableau, TabPy, which allows you to call Python functions directly from Tableau. The API that was used originally for TabPy has been expanded to make it more generalizable to any external analytics engine. Previously, analytics extensions were known as external services.

To use the API, you don't need to install anything new in Tableau. You just need your analytics extension implementation and Tableau Desktop or Tableau Server.
