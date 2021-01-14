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

In Tableau 20.1 there is an issue with HTTP headers which sets the Content-Type as: application/x-www-form-urlencoded instead of application/json. This doesn't affect the actual data being sent, but may interfere with analytics extensions that explicitely expect a JSON content type. At present for any existing services that expect JSON, the workaround is the cast the incoming data as JSON. This issue is fixed in Tableau 20.2.

### Dummy /eval Call is Made When Authentication is Enabled in Tableau

When authentication is configured on in Tableau, to configure a connected session when the 'Test Connection' button is clicked, or when a SCRIPT_X function is evaluated, Tableau will make a dummy POST /eval call to the Analytics Extension.  Currently this POST request takes the form of: {'script': 'return int(1)', 'data': {'_arg1': [4]}}. To handle this call and correctly authenticate, your server will need to return an integer 1 for eval requests with the script: return int(1).
