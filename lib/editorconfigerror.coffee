###*
 * The default SyntaxError class doesn't accept fileName or lineNumber args.
 * Also, being able to pass in the context (text that threw the error) is nice.
###
class EditorConfigError extends Error
  constructor: (@message, @fileName, @lineNumber, @context) ->

  toString: ->
    text = @fileName
    if @lineNumber?
      text += ":#{@lineNumber}"
    if @context?
      text += "\n#{context}"
    text += "\nEditorConfigError: #{@message}"

module.exports = EditorConfigError
