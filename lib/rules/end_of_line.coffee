LineRule = require '../line-rule'

class EndOfLine extends LineRule
  propertyName: 'end_of_line'

  eolRegex: /(?:\r\n|\n|\r)?$/

  fixLine: (line) ->
    line.replace(@eolRegex, (match) =>
      switch @setting
        when 'crlf'
          '\r\n'
        when 'cr'
          '\r'
        else # 'lf' or ''
          '\n'
    )

  inferLine: (line) ->
    switch line.match(@eolRegex)?[0]
      when '\r\n'
        'crlf'
      when '\n'
        'lf'
      when '\r'
        'cr'
      when undefined
        null

module.exports = EndOfLine
