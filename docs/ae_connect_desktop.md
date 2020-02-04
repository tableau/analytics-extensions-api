---
title: Connect from Tableau Desktop
layout: docs
---

1. Start your analytics extension server.
1. Follow the instructions in the Tableau Desktop and Web Authoring Help to [Configure an analytics extensions connection](https://help.tableau.com/v2020.1/pro/desktop/en-us/r_connection_manage.htm#configure-an-analytics-extensions-connection). In the *Select an External Service* drop-down menu, select **TabPy/External API**.

**Note**: Do not select the RServe connection type. It uses a different protocol and will not work with services written using the Analytics Extensions API.

![Connection window]({{ site.baseurl }}/docs/assets/images/ext_serv_2.png)

