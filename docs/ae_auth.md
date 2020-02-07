---
title: Authentication
layout: docs
---

Authentication is optional for the ```GET /info``` method.

Basic authentication is supported with username and password. 

With the /evaluate method, the stored username and password credentials are passed by Tableau to the Analytics Extension using the HTTP headers.

On the Tableau side, Authentication is configured in Tableau Desktop via the Analytics Extensions UI: [https://help.tableau.com/current/pro/desktop/en-us/r_connection_manage.htm#configure-an-external-service-connection](https://help.tableau.com/current/pro/desktop/en-us/r_connection_manage.htm#configure-an-external-service-connection)

In Server up to version 20.1, connections with are configured for Analytics Extensions using the TSM Security command: [https://help.tableau.com/current/server/en-us/cli_security_tsm.htm#tsm_security_vizql-extsvc-ssl-enable](https://help.tableau.com/current/server/en-us/cli_security_tsm.htm#tsm_security_vizql-extsvc-ssl-enable)
