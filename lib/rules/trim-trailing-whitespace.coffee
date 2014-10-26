LineRule = require '../line-rule'

class TrimTrailingWhitespace extends LineRule
  propertyName: 'trim_trailing_whitespace'

  ###*
   * The first group is any trailing whitespace, and the 2nd group is the line
     ending (which might not be there if `insert_final_newline` is false).
   * @type {Regex}
  ###
  _trailingWhitespace: /([^\S\r\n]+)(\r\n|\n|\r|)$/
  fixLine: (line) =>
    if @setting
      match = line.match(@_trailingWhitespace)
      # join the line (without trailing space), with the captured line ending (if
      # there is one)
      if match?
        return line[...-(match[0].length)] + match[2]
    return line

  infer: =>
    @fileAsLines().then((lines) =>
      for line in lines
        # if any lines have trailing whitespace, it's not being trimmed
        if not @inferLine(line) then return false
      return true
    )

  inferLine: (line) =>
    not @_trailingWhitespace.test(line)

module.exports = TrimTrailingWhitespace
