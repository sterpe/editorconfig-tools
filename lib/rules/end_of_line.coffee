LineRule = require '../line-rule'

class EndOfLine extends LineRule
  propertyName: 'end_of_line'

  fixLine: (line) ->
    line.replace(/(?:\r\n|\n|\r)?$/, (match) =>
      switch @setting
        when 'crlf'
          '\r\n'
        when 'cr'
          '\r'
        else # 'lf' or ''
          '\n'
    )

  inferLine: (line) ->
    switch line.match(/(?:\r\n|\n|\r)$/)?[0]
      when '\r\n'
        'crlf'
      when '\n'
        'lf'
      when '\r'
        'cr'
      when undefined
        null

module.exports = EndOfLine
