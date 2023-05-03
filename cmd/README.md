About

A Telegram bot that ...

Bot URL : https://t.me/123

How to use

Please use commands below to manage your notification

    /start - obviously, to start using bot
    /set - you will be prompted to questionnaire.
        Question #1: What I should remind you? - Just type what you want to be reminded of. (example: Turn off oven)
        Question #2: After how long to warn you? - Provide duration for time when you should be notified (example: 30m)
    /dismiss - to dismiss notification on any stage
    /ping - to check if notification was set
    /help - to see help


How to build and run
Prerequisites (for all installation methods)

    Golang should be installed
    Bot token should be assigned to system env variable with name TELE_TOKEN


Local build and run

    Just build using go build
    Run with ./kbot start
    
Docker

    Build image: docker build -t kbot . 
    Run container: docker run -d --name kbot -e TELE_TOKEN=$TELE_TOKEN kbot
    Stop and remove container: docker stop kbot | docker rm kbot
