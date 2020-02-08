---
title: Authentication
layout: docs
---

The requirement for authentication in a connection is indicated by including the optional authentication parameter in the features parameter for the ```GET /info``` method.

Tableau currently supports basic authentication with username and password. 

The username and password values that have been configured in Tableau are passed to the Analytics Extension using the HTTP headers of calls to the /evaluate method.

On the Tableau side, Authentication is configured in Tableau Desktop via the Analytics Extensions UI: [https://help.tableau.com/current/pro/desktop/en-us/r_connection_manage.htm#configure-an-external-service-connection](https://help.tableau.com/current/pro/desktop/en-us/r_connection_manage.htm#configure-an-external-service-connection)

In Server up to version 20.1, connections with are configured for Analytics Extensions using the TSM Security command: [https://help.tableau.com/current/server/en-us/cli_security_tsm.htm#tsm_security_vizql-extsvc-ssl-enable](https://help.tableau.com/current/server/en-us/cli_security_tsm.htm#tsm_security_vizql-extsvc-ssl-enable)
