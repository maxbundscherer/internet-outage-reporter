# Internet Outage Reporter

A tool that regularly checks the internet connection. Sends a notification via IFTTT when the internet connection was interrupted.

``internet - outage - reporter - down - notifcation - ifttt`` 

[![shields.io](https://img.shields.io/badge/license-Apache2-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.txt)

Author: [Maximilian Bundscherer](https://bundscherer-online.de)

## Let's get started

### Config IFTTT

1. Create IFTTT Applet
    - If: `Receive a web request`
    - Then: `Send me an email`

2. Get IFTTT API Key
    - Go to [IFTTT](https://ifttt.com/maker_webhooks)
    - Click on `Documentation`
    - Copy your API Key

### Config Tool

1. Add IFTTT API Key in `ior.sh`
    - `vim ior.sh`

2. Test Notification
    - `./ior.sh -test`

3. Add Cronjob
    - `crontab -e`
    - `*/5 * * * * /<PATH_TO_REPO>/ior.sh -check` (evey 5 minutes)
