LineRule = require '../line-rule'
W = require 'when'

###*
 * @todo Implement fixing and inferring properly. It sucks right now.
###
class MaxLineLength extends LineRule
  propertyName: 'max_line_length'

  infer: ->
    deferred = W.defer()
    deferred.resolve(80) # most code-bases use that :P
    return deferred.promise

  checkLine: (line) ->
    @inferLine(line) <= @setting

  inferLine: (line) ->
    line.length

module.exports = MaxLineLength
