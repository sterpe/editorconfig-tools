LineRule = require '../line-rule'
{eolRegex} = require '../util'

class EndOfLine extends LineRule
  propertyName: 'end_of_line'

  fixLine: (line) =>
    line.replace(eolRegex, (match) =>
      switch @setting
        when 'crlf'
          '\r\n'
        when 'cr'
          '\r'
        when 'lf'
          '\n'
        else
          throw new Error("unsupported value for end_of_line: #{@setting}")
    )

  ###*
   * Infer the line ending, returning `undefined` if there is no line ending
   * @param {String} line
  ###
  inferLine: (line) ->
    switch line.match(eolRegex)?[0]
      when '\r\n'
        'crlf'
      when '\n'
        'lf'
      when '\r'
        'cr'

module.exports = EndOfLine
