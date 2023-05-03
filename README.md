About

A Telegram bot that processes a message from users and responds to

Bot URL : https://t.me/asXFvvr_bot

How to use

Please use commands below to manage your notification

    /start hello - Returns the Bot version


How to build and run
Prerequisites (for all installation methods)

    Golang should be installed
    Bot token should be assigned to system env variable with name TELE_TOKEN


Local build and run

    go build -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=v1.0.0
    ./kbot start

Docker

    Build image: docker build -t kbot . 
    Run container: docker run -d --name kbot -e TELE_TOKEN=$TELE_TOKEN kbot
    Stop and remove container: docker stop kbot | docker rm kbot
