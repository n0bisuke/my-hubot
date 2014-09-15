# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /hubot/version
#   /hubot/ping
#   /hubot/time
#   /hubot/info
#   /hubot/ip

spawn = require('child_process').spawn

module.exports = (robot) ->

  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version

  robot.router.post "/hubot/ping", (req, res) ->
    res.end "PONG"

  robot.router.get "/hubot/time", (req, res) ->
    res.end "Server time is: #{new Date()}"

  robot.router.get "/hubot/info", (req, res) ->
    child = spawn('/bin/sh', ['-c', "echo I\\'m $LOGNAME@$(hostname):$(pwd) \\($(git rev-parse HEAD)\\)"])

    child.stdout.on 'data', (data) ->
      res.end "#{data.toString().trim()} running node #{process.version} [pid: #{process.pid}]"
      child.stdin.end()

  robot.router.get "/hubot/ip", (req, res) ->
    robot.http('http://ifconfig.me/ip').get() (err, r, body) ->
      res.end body

  robot.router.post "/hubot/qiita_post", (req, res) ->
    action_name = req.body.action
    user_name = req.body.item.user.url_name
    url = req.body.item.url
    title = req.body.item.title
    console.log(req.body.action);
    console.log(req.body.item.user);
    console.log('__',req.body.item);
    console.log('^^^',req.body.user);
    message = user_name + 'が記事を'+ action_name + 'しました。['+ title + ']'
    robot.messageRoom('#qiita', message)
    robot.messageRoom('#qiita', url)
