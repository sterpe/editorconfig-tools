BPromise = require 'bluebird'
LineRule = require '../line-rule'

EditorConfigError = require '../editorconfigerror'

###*
 * @todo Implement fixing and inferring properly. It sucks right now.
###
class MaxLineLength extends LineRule
  propertyName: 'max_line_length'

  ###*
   * Lifted from end_of_line.coffee
  ###
  _eolRegex: /(?:\r\n|\n|\r)?$/

  infer: ->
    BPromise.resolve(80) # most code-bases use that :P

  checkLine: (line, lineNum) =>
    lineLength = @inferLine(line)
    if lineLength > @setting
      throw new EditorConfigError(
        "line is #{lineLength} chars, it should be #{@setting}"
        @file.path
        lineNum
      )

  inferLine: (line) =>
    # the line ending doesn't count. subtract it
    line.length - line.match(@_eolRegex)?[0].length

module.exports = MaxLineLength
