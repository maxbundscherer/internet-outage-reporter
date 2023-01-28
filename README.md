# Internet Outage Reporter

A tool that regularly checks the internet connection. Sends a notification via IFTTT when the internet connection was interrupted.

``internet - outage - reporter - down - notifcation - ifttt`` 

[![shields.io](https://img.shields.io/badge/license-Apache2-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.txt)

Author: [Maximilian Bundscherer](https://bundscherer-online.de)

## Let's get started

### Config IFTTT

1. Create IFTTT Applet
    - Name: `ior`
    - If: `Receive a web request`
    - Then: `Send me an email`
        - Subject: `IOR Report`
        - Body: `{{Value1}}`

2. Get IFTTT API Key
    - Go to [IFTTT](https://ifttt.com/maker_webhooks)
    - Click on `Documentation`
    - Copy your API Key

### Config Tool

1. Add IFTTT API Key in `ior.sh`
    - `vim ior.sh`
    - Add `IFTTT API Key`
    - Add `Local Path`
    - (opt.) Change `My Location`
    - (opt.) Change `IFTTT Event Name`

2. Test Notification
    - `./ior.sh -test`

3. Add Cronjob
    - `sudo crontab -e`
    - `*/5 * * * * /<PATH_TO_REPO>/ior.sh -check` (every 5 minutes) (add for checking status every 5 minutes)
    - `*/15 * * * * /<PATH_TO_REPO>/ior.sh -test` (every 15 minutes) (add for sending test notification every 15 minutes) (not recommend)

## Debug

- In `last-check.txt`, the time of the last check is stored. Useful for cron job testing.
- `first-down.txt` stores the first time the internet went down. This file is deleted if the notifications have been sent.
