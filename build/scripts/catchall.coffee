Wolfram = require('wolfram-alpha').createClient(process.env.HUBOT_WOLFRAM_APPID)

pandorabot_url = "https://www.pandorabots.com/pandora/talk-xml";
bot_id = "b009ed816e3420c1";
bot_name = "Bot";
#formData = new FormData();

module.exports = (robot) ->
  robot.catchAll (msg) ->
    r = new RegExp "^(?:#{robot.alias}|#{robot.name}) (.*)", "i"
    matches = msg.message.text.match(r)
    if matches != null && matches.length > 1

      data = JSON.stringify({
                'botid': bot_id,
                'input': matches[1],
                'custid': 'sergio',
                })

      formData = '?botid='+bot_id+'&input='+matches[1]+'&custid=sergio'

      robot.http(pandorabot_url+formData)
           .header('Content-Type', 'application/x-www-form-urlencoded')
           .post(data) (err, res, body) ->

            if res.statusCode is 200
             #msg.send data
             #msg.send "We got a response from the bot."
             botresponse = body.match(/<that>(.*)<\/that>/)
             msg.send botresponse[1].replace(/&amp;/g, '&' ).replace(/&lt;/g, '<').replace(/&quot;/g, '"').replace(/&#039;/g, '\'')
            else
              Wolfram.query matches[1], (e, result) ->
                if result and result.length > 0
                  msg.send "No response from bot. Asking Wolfram."
                  msg.send body
                  msg.send result[1]['subpods'][0]['text']
                else
                  msg.send 'Beats me'

              msg.finish()
