Rule = require '../rule'

class InsertFinalNewline extends Rule
  propertyName: 'insert_final_newline'

  ###*
   * @type {Regex}
  ###
  FINAL_NEWLINE: /(?:\r\n|\n|\r)$/

  fix: ->
    @file.read(encoding:'utf8').then((data) =>
      @file.write(data.replace(@FINAL_NEWLINE, (match) =>
        if @setting is false
          ''
        else
          # choose the correct type of newline to insert
          switch @editorconfig['end_of_line']
            when 'crlf'
              '\r\n'
            when 'cr'
              '\r'
            else # 'lf' or undefined
              '\n'
      ))
    )

  infer: ->
    @file.read(encoding:'utf8').then((data) =>
      @FINAL_NEWLINE.test(data)
    )

module.exports = InsertFinalNewline
