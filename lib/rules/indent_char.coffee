LineRule = require '../line-rule'
detectIndent = require 'detect-indent'

EditorConfigError = require '../editorconfigerror'

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

  infer: ->
    @file.read(encoding: 'utf8').then((data) ->
      detectedSetting = detectIndent(data)
      if not detectedSetting?
        throw new Error("Cannot infer #{@propertyName}")
      return detectedSetting
    )

module.exports = IndentChar
