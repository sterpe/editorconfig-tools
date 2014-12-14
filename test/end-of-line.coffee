require 'should'
File = require 'fobject'

EndOfLine = require '../lib/rules/end-of-line'

describe 'end_of_line rule unit', ->
  before ->
    @rule = new EndOfLine('fakefile')

  it 'should have the correct propertyName', ->
    @rule.propertyName.should.eql('end_of_line')

  it 'should detect line endings correctly', ->
    @rule.inferLine('\n').should.eql('lf')
    @rule.inferLine('text\n').should.eql('lf')
    @rule.inferLine('text\r\n').should.eql('crlf')
    @rule.inferLine('text\r').should.eql('cr')
    (@rule.inferLine('text')?).should.eql(false)

  it 'should fix line endings', ->
    @rule.fixLine('\n').should.eql('\n')
    @rule.fixLine('text\n').should.eql('text\n')
    @rule.fixLine('text\r\n').should.eql('text\n')
    @rule.fixLine('text\r').should.eql('text\n')
    @rule.fixLine('text').should.eql('text')

describe 'end_of_line rule integration tests', ->
  before ->
    @file = new File('./test/fixtures/end-of-line/file')
    @rule = new EndOfLine('./test/fixtures/end-of-line/file')

  after ->
    # reset file state
    @file.write(
      'line one\r\nline two\r\nline three\r\n'
    )

  it 'should detect lf line endings', ->
    @file.write(
      'line one\nline two\nline three\n'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql('lf')
    )

  it 'should detect crlf line endings', ->
    @file.write(
      'line one\r\nline two\r\nline three\r\n'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql('crlf')
    )

  it 'should fix lf line endings', ->
    @file.write(
      'line one\nline two\nline three\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\r\nline two\r\nline three\r\n')
    )

  it 'should fix mixed line endings', ->
    @file.write(
      'line one\nline two\r\nline three\r'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\r\nline two\r\nline three\r\n')
    )

  it 'should fix line endings without adding a trailing line', ->
    @file.write(
      'line one\nline two\nline three'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\r\nline two\r\nline three')
    )
