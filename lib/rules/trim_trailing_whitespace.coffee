LineRule = require '../line-rule'

class TrimTrailingWhitespace extends LineRule
  propertyName: 'trim_trailing_whitespace'

  ###*
   * @type {Regex}
  ###
  TRAILING_WHITESPACE: /\s+$/

  fixLine: (line) ->
    # will always result in a 2 element array, with the 2nd being an empty
    # string
    line.split(TRAILING_WHITESPACE)[0]

  inferLine: (line) ->
    not TRAILING_WHITESPACE.test(line)

module.exports = TrimTrailingWhitespace
