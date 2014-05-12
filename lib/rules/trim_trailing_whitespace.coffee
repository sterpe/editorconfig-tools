LineRule = require '../line-rule'

class TrimTrailingWhitespace extends LineRule
  propertyName: 'trim_trailing_whitespace'

  ###*
   * The first group is any trailing whitespace, and the 2nd group is the line
     ending (which might not be there if `insert_final_newline` is false).
   * @type {Regex}
  ###
  TRAILING_WHITESPACE: /([^\S\r\n]+)(\r\n|\n|\r)?$/

  fixLine: (line) ->
    match = line.match(@TRAILING_WHITESPACE)
    # join the line (without trailing space), with the captured line ending (if
    # there is one)
    line[...-(match[0].length)] + (match[2] or '')

  inferLine: (line) ->
    not @TRAILING_WHITESPACE.test(line)

module.exports = TrimTrailingWhitespace
