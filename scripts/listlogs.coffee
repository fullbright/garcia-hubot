# Description:
#   Initially designed to list the logs then while following the tutorial, I end up putting other features in it.
#
# Dependencies:
#   "JSON": latest
#
# Configuration:
#   HUBOT_SYSTEM_ACCOUNT
#   HUBOT_TV_IPADDRESS
#
# Commands:
#   hubot system account - Print the system account used to perform the actions locally
#   mylogs - prints the list of all the available logs. Default is useless. Other values : replay, docker
#   list me my * logs - prints the list of all the available logs. Default is useless. Other values : replay, docker
#   what are the * logs - same as list me my * logs.
#   turn on tv - turn on the TV ;)
#   download replays - Downloads the configured replays.
#   host lookup <host> - look up the host in the internet
#   youtube replays file types - print which types of file we have in the youtube folder
#
# Notes:
#   Still work in progress.
#
# Author:
#   Full Bright <full3right@gmail.com>


enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
systemAccount = process.env.HUBOT_SYSTEM_ACCOUNT
tvIpaddress = process.env.HUBOT_TV_IPADDRESS
friendUsername = "fullbright"

module.exports = (robot) ->

    robot.listen(
        (message) -> # Match function
            # Occassionally respond to things that Steve says
            message.user.name is friendUsername and Math.random() > 0.8
        (response) -> # Standard listener callback
            # Let Steve know how happy you are that he exists
            friendReplies = ['Hi #{friendUsername} ! You are my best friend ! ', "Hello #{friendUsername}, nice to read from you again", "HI #{friendUsername}! YOU'RE MY BEST FRIEND! (but only like #{response.match * 100}% of the time)" ]
            response.reply response.random friendReplies
    )

    # List the log files
    robot.enter (res) ->
        res.send res.random enterReplies
    robot.leave (res) ->
        res.send res.random leaveReplies

    robot.hear /system account/i, (res) ->

        if systemAccount != undefined
            res.send "#{systemAccount} is my system account."
        else
            res.send "You need to define the HUBOT_SYSTEM_ACCOUNT variable."

    robot.hear /mylogs/i, (res) ->
        # when we hear the log file
        res.send 'here are the logs generated on the server'

    robot.hear /download replays/i, (res) ->
        @exec = require('child_process').exec
        command = "/home/fullbright/fr-replay-downloader/download_all.sh"

        res.send "Executing command #{command}"

        @exec command, (error, stdout, stderr) ->
            res.send error
            res.send stdout
            res.send stderr

    robot.respond /host lookup (.*)$/i, (msg) ->
        hostname = msg.match[1]
        @exec = require('child_process').exec
        command = "host #{hostname}"

        msg.send "Looking up #{hostname}..."
        msg.send "This is the command #{command}."

        @exec command, (error, stdout, stderr) ->
            msg.send error
            msg.send stdout
            msg.send stderr

    robot.respond /youtube replays file types/i, (res) ->
        command = "find /home/fullbright/fr-replay-downloader/youtube/watchlater/ -type f -name \"*.*\" | awk -F. '{print $NF}' | sort -u"

        @exec = require('child_process').exec
        res.send "Issuing command #{command}"

        @exec command, (error, stdout, stderr) ->
            res.send error
            res.send stdout
            res.send stderr

    robot.respond /list me my (.*) logs/i, (res) ->
        # what we will respond
        logType = res.match[1]
        res.reply "sure #{logType} logs. Here you go"

    robot.hear /what are the (.*) logs/i, (res) ->
        res.emote "let me get those #{logType} for you"

    robot.hear /turn on tv/i, (response) ->
        url = "http://#{tvIpaddress}:8080/remoteControl/cmd?operation=01&key=116&mode=0"
        robot.http(url)
            .header('Accept', 'application/json')
            .get() (err, res, body) ->

            if response.getHeader('Content-Type') isnt 'application/json'
                response.send "Didn't get back JSON :("
                return

            if err
                response.send "Encountered an error :( #{err}"
                return

            if res.statusCode isnt 200
                response.send "Request didn't come back HTTP 200 :("
                return

            try
                data = JSON.parse body
                if data
                    response.send "#{data.result} is what the server send back. Message is #{data.result.message}"
                else
                    response.send "Got back #{body}"
            catch
                response.send "Ran into an error while converting the JSON"
                return
