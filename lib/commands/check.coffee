editorconfig = require 'editorconfig'
fs = require 'fs'
path = require 'path'
W = require 'when'

Rules = require '../rules'

check = (args, options={}, callback = (->)) ->
  files = args.files
  promises = []
  Object.keys(Rules).forEach (ruleName) ->
    Rule = Rules[ruleName]
    files.forEach (filePath) ->
      if fs.lstatSync(filePath).isDirectory() then return
      property = new Rule(filePath)
      promises.push property.check().catch((err) ->
        throw new Error(
          "invalid\nfile: #{filePath}:#{err}\nrule: #{property.propertyName}"
        )
      ).done( ->
        console.log "#{filePath} passed #{property.propertyName} rule"
      )
  W.all(promises).done( ->
    console.log 'done'
  )


module.exports = check
