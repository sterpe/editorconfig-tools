Rule = require '../rule'
W = require 'when'

class InsertFinalNewline extends Rule
  propertyName: 'insert_final_newline'

  ###*
   * @type {Regex}
   * @private
  ###
  _finalNewline: /(?:\r\n|\n|\r)?$/

  fix: =>
    super().then( =>
      @file.read(encoding:'utf8')
    ).then((data) =>
      # don't add a newline to empty files
      if data is '' then return W.resolve()

      @file.write(data.replace(@_finalNewline, (match) =>
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

  infer: =>
    @file.read(encoding:'utf8').then((data) =>
      if data is '' then return true # empty files don't need final newlines
      finalNewline = data.match(@_finalNewline)
      return (finalNewline? and finalNewline[0] isnt '')
    )

module.exports = InsertFinalNewline
