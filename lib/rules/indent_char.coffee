LineRule = require '../line-rule'
detectIndent = require 'detect-indent'

class IndentChar extends LineRule
  ###*
   * This actually isn't an official property. It's a combination of the
     `indent_style` and `indent_size` properties that's used internally to do
     them both at once.
  ###
  propertyName: 'indent_char'

  fix: ->
    @infer().then((detectedSetting) =>
      if not detectedSetting?
        throw new Error('couldn\'t detect indentation')
      if @setting is detectedSetting then return
      @indentRegex = new RegExp("^(?:#{@detectedSetting})*")
      super() # loop through all the lines, fixing indentation
    )

  fixLine: (line) ->
    match = line.match(@indentRegex)[0]
    totalIndents = match.length / @setting.length
    Array(totalIndents + 1).join(@setting) + line[match.length..]

  ###*
   * This is actually a copy of the one in ../rule.coffee
   * @todo Check on a per-line basis to find specific lines that don't match the
     indent size.
  ###
  check: ->
    @infer().then((detectedSetting) =>
      if detectedSetting isnt @setting
        throw new Error('invalid')
    )

  infer: ->
    @file.read().then((data) -> detectIndent(data))

module.exports = IndentChar
