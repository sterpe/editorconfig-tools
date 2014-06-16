editorconfig = require 'editorconfig'
fs = require 'fs'
path = require 'path'
W = require 'when'
_ = require 'lodash'
requireTree = require 'require-tree'

Rules = requireTree '../rules'
delete Rules.charset

exitCode = 0

check = (args, options={}) ->
  files = args.files
  console.log "checking #{files.length} files"
  promises = []
  Object.keys(Rules).forEach (ruleName) ->
    Rule = Rules[ruleName]
    files.forEach (filePath) ->
      if fs.lstatSync(filePath).isDirectory() then return
      property = new Rule(filePath)
      promises.push(
        property.check().then(
          (res) ->
            res: res
            file: filePath
            rule: ruleName
          (err) ->
            file: filePath
            rule: ruleName
            error: err
        )
      )
  W.all(promises).done((res) ->
    files = _.uniq _.pluck(res, 'file')
    for file in files
      matches = _.where res, {file: file}
      verbose = true
      if verbose or _.compact(_.pluck(matches, 'error')).length > 0
        console.log file
        for match in matches
          if match.error?
            exitCode = 1
            text = "  failed #{match.rule}"
            if match.error.lineNumber?
              text += " on line #{match.error.lineNumber}"
            if match.error.message?
              text += ": #{match.error.message}"
            console.log text
          else if verbose
            if match.res is null
              console.log "  ignored #{match.rule} (no setting defined)"
            else
              console.log "  passed #{match.rule}"
        console.log ''
    process.exit(exitCode)
  )

indentText = (text) ->
  text = text.split('\n')
  for line, i in text
    text[i] = "    #{line}"
  return text.join('\n')

module.exports = check
