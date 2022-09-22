# Tableau Analytics Extensions API

[![Tableau Supported](https://img.shields.io/badge/Support%20Level-Tableau%20Supported-53bd92.svg)](https://www.tableau.com/support-levels-it-and-developer-tools)

## Why the Tableau Analytics Extensions API?

The Analytics Extensions API lets you extend Tableau to dynamically include popular data science programming languages and external tools and platforms.

## Contributions

Code contributions and improvements by the community are welcomed!
See the LICENSE file for current open-source licensing and use information.

Before we can accept pull requests from contributors, we require a signed [Contributor License Agreement (CLA)](http://tableau.github.io/contributing.html).

## Documentation

[Visit the project website and read the documentation here.](https://tableau.github.io/analytics-extensions-api/)

## Issues

Use [Issues](https://github.com/tableau/analytics-extensions-api/issues) to log any problems or bugs you encounter in the docs.

Known Issue - In Tableau 20.1 there is an issue with HTTP headers which sets the Content-Type as: application/x-www-form-urlencoded instead of application/json. This doesn't affect the actual data being sent, but may interfere with analytics extensions that explicitely expect a JSON content type. At present for any existing services that expect JSON, the workaround is the cast the incoming data as JSON. This issue should be corrected shortly.
