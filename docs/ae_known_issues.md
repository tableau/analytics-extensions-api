---
title: Known Issues for the Tableau Analytics Extensions API
layout: docs
--- 

The following section describes some issues in the current release of the Analytics Extensions API where the API does not behave as expected.  

For information about what is new or has changed in each release, see the [Release Notes]({{ site.baseurl }}/docs/ae_release-notes.html).

**In this section**

* TOC
{:toc}


### Tableau Prep Builder is not yet supported

Using the Analytics Extensions API with Tableau Prep Builder is not currently supported.

### Tableau 20.1 HTTP content type headers have changed

In Tableau 20.1 there is an issue with HTTP headers which sets the Content-Type as: application/x-www-form-urlencoded instead of application/json. This doesn't affect the actual data being sent, but may interfere with analytics extensions that explicitely expect a JSON content type. At present for any existing services that expect JSON, the workaround is the cast the incoming data as JSON. This issue should be corrected shortly.
