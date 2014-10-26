path = require 'path'
packageInfo = require(path.join(__dirname, '../package.json'))
ArgumentParser = require('argparse').ArgumentParser

argparser = new ArgumentParser(
  version: packageInfo.version
  addHelp: true
  description: packageInfo.description
)
subparsers = argparser.addSubparsers(
  title: 'action'
  dest: 'action'
)
infer = subparsers.addParser(
  'infer'
  help: 'Infer .editorconfig settings from one or more files'
  addHelp: true
)
infer.addArgument(
  ['files']
  type: 'string'
  metavar: 'FILE'
  nargs: '+'
  help: 'The file(s) to use'
)

check = subparsers.addParser(
  'check'
  help: 'Validate that file(s) adhere to .editorconfig settings, returning an
  error code if they don\'t'
  addHelp: true
)
check.addArgument(
  ['files']
  type: 'string'
  metavar: 'FILE'
  nargs: '+'
  help: 'The file(s) to use'
)

fix = subparsers.addParser(
  'fix'
  help: 'Fix formatting errors that disobey .editorconfig settings'
  addHelp: true
)
fix.addArgument(
  ['files']
  type: 'string'
  metavar: 'FILE'
  nargs: '+'
  help: 'The file(s) to use'
)

argv = argparser.parseArgs()


editorconfig = require 'editorconfig'
fs = require 'fs'
path = require 'path'
W = require 'when'
_ = require 'lodash'
requireTree = require 'require-tree'
Rules = requireTree './rules'

exitCode = 0

if argv.action is 'check'
  promises = []
  Object.keys(Rules).forEach (ruleName) ->
    Rule = Rules[ruleName]
    argv.files.forEach (filePath) ->
      if fs.lstatSync(filePath).isDirectory() then return
      property = new Rule(filePath)
      promises.push(
        property.check().then(
          (res) ->
            res: res
            file: filePath
            rule: property.propertyName
          (err) ->
            file: filePath
            rule: property.propertyName
            error: err
        )
      )

  W.all(promises).done((res) ->
    files = _.uniq _.pluck(res, 'file')
    for file in files
      matches = _.where res, file: file
      verbose = true
      if verbose or _.compact(_.pluck(matches, 'error')).length > 0
        for match in matches
          if match.error?
            exitCode = 1
            text = "#{file} failed #{match.rule}"
            if match.error.lineNumber?
              text += " on line #{match.error.lineNumber}"
            if match.error.message?
              text += ": #{match.error.message}"
            console.log text
          else if verbose
            if match.res is null
              console.log "#{file} ignored #{match.rule} (no setting defined)"
            else
              #console.log "#{file} passed #{match.rule}"
    process.exit(exitCode)
  )
else if argv.action is 'fix'
  promises = []
  Object.keys(Rules).forEach (ruleName) ->
    Rule = Rules[ruleName]
    argv.files.forEach (filePath) ->
      if fs.lstatSync(filePath).isDirectory() then return
      property = new Rule(filePath)
      promises.push(
        property.fix().then(
          (res) ->
            res: res
            file: filePath
            rule: property.propertyName
          (err) ->
            file: filePath
            rule: property.propertyName
            error: err
        )
      )
else if argv.action is 'infer'
  promises = []
  Object.keys(Rules).forEach (ruleName) ->
    Rule = Rules[ruleName]
    argv.files.forEach (filePath) ->
      if fs.lstatSync(filePath).isDirectory() then return
      property = new Rule(filePath)
      promises.push(
        property.infer().then(
          (res) ->
            res: res
            file: filePath
            rule: property.propertyName
          (err) ->
            file: filePath
            rule: property.propertyName
            error: err
        )
      )

  W.all(promises).done((res) ->
    rules = {}
    groups = _.groupBy(res, 'rule')
    for property, group of groups
      distributionOfValues = _.pairs _.countBy _.pluck(group, 'res'), (x) -> x
      sortedValues = _.sortBy distributionOfValues, (x) -> -x[1]

      # most common value gets to be global
      rules['[*]'] ?= []
      rules['[*]'].push([property, sortedValues[0][0]])

      # the rest are given a selector based on what files they hit
      for value in sortedValues[1..]
        if value[0] is 'null' then continue
        files = _.pluck _.where(group, res: value[0]), 'file'
        selector = "[{#{files.join(',')}}]"
        rules[selector] ?= []
        rules[selector].push([property, value[0]])


    for selector, ruleGroup of rules
      console.log selector
      for rule in ruleGroup
        if rule[0] is 'indent_char'
          if rule[1] is '\t'
            console.log 'indent_style: tab'
          else
            console.log 'indent_style = space'
            console.log "indent_size = #{rule[1].length}"
        else
          console.log "#{rule[0]} = #{rule[1]}"

      console.log ''
  )
