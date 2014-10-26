LineRule = require '../line-rule'

class EndOfLine extends LineRule
  propertyName: 'end_of_line'

  _eolRegex: /(?:\r\n|\n|\r)$/

  fixLine: (line) ->
    line.replace(@_eolRegex, (match) =>
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

  inferLine: (line) ->
    switch line.match(@_eolRegex)?[0]
      when '\r\n'
        'crlf'
      when '\n'
        'lf'
      when '\r'
        'cr'
      when undefined
        null

module.exports = EndOfLine
