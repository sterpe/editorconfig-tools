Rule = require './rule'

class LineRule extends Rule
  ###*
   * Get the contents of the file as an array of lines.
   * @return {Promise} A promise for the lines as an array of strings.
  ###
  fileAsLines: ->
    @file.read(encoding:'utf8').then((data) =>
      lines = data.split(/(\r\n|\n|\r)/)
      # right now the capturing group from the regex is every other element in
      # `lines`. Those groups need to be joined with the line before them.
      i = 0
      joinedLines = []
      console.log lines.length
      while i < lines.length
        joinedLines.push lines[i] + (lines[i + 1] or '')
        i += 2
      console.log joinedLines
      if joinedLines[-1..][0] is ''
        # split leaves an empty string as the last element in the array if
        # the file ends with a linebreak (as it should). remove that.
        joinedLines = joinedLines[...-1]
      return joinedLines
    )

  fix: ->
    @fileAsLines().then((lines) =>
      newLines = []
      newLines.push(@fixLine line) for line in lines
      @file.write(newLines.join())
    )

  check: ->
    @fileAsLines().then((lines) =>
      for line in lines
        if not @checkLine line
          throw new Error('invalid line')
    )

  infer: ->
    @fileAsLines().then((lines) =>
      lineSettings = [] # list of all settings found in the file
      for line in lines
        lineSetting = @inferLine line
        if lineSetting not in lineSettings
          # keep the array elements unique
          lineSettings.push lineSetting
      if lineSettings.length is 1
        return lineSettings[0]
      else
        throw new Error(
          "multiple setting values found: #{lineSettings.join(', ')}"
        )
    )

  ###*
   * @param {String} line
   * @return {String} The fixed line.
  ###
  fixLine: (line) ->
    throw new Error("Unable to fix #{@propertyName}")

  ###*
   * Check if the line is valid according to the rule. By default it just uses
     `inferLine` to check aginst the setting for the rule.
   * @param {String} line
   * @return {Boolean} If the line is valid
  ###
  checkLine: (line) ->
    @inferLine(line) is @setting

  ###*
   * @param {String} line
   * @return {String|Integer|Boolean} Setting value for the line.
  ###
  inferLine: (line) ->
    throw new Error("Cannot infer #{@propertyName}")

module.exports = LineRule
