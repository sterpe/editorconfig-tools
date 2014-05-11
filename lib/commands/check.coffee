editorconfig = require("editorconfig")
fs = require("fs")
path = require("path")

rules = require '../rules'

check = (args, options={}, callback = (->)) ->
  done = ->
    unless options.boring
      messages.forEach (message) ->
        console.log message.filename + ":", message.msg
        return
    callback messages

  messages = []
  files = args.files
  console.log files
  callback() if not files or not files.length
  count = 0
  files.forEach (filename) ->
    settings = editorconfig.parse(filename)
    reporter = report: (msg) ->
      messages.push
        filename: filename
        msg: msg
      return

    ruleNames = Object.keys(settings)
    ruleNames.forEach (ruleName) ->
      console.log rules[ruleName]
      rule = new rules[ruleName]()
      setting = settings[ruleName]
      fs.readFile filename,
        encoding: "utf8"
        (err, data) ->
          if err then throw err
          rule.check reporter, setting, data
          done() if ++count is files.length * ruleNames.length
          return
      return
    return
  return

module.exports = check
