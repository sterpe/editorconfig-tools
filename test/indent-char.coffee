require 'should'
File = require 'fobject'

IndentChar = require '../lib/rules/indent-char'

describe 'indent_style/indent_size rule unit', ->
  before ->
    @rule = new IndentChar('fakefile')

  it 'should have the correct propertyName', ->
    @rule.propertyName.should.eql('indent_char')

describe 'indent_style/indent_size rule integration (spaces)', ->
  before ->
    @file = new File('./test/fixtures/indent-char-space/file')
    @rule = new IndentChar('./test/fixtures/indent-char-space/file')

  after ->
    # reset file state
    @file.write(
      'line one\n  line two\n    line three\n'
    )

  it 'should detect indentation', ->
    @file.write(
      'line one\n  line two\n    line three\n'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql('  ')
    )

  it 'should fix tab indentation', ->
    @file.write(
      'line one\n\tline two\n\t\tline three\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\n  line two\n    line three\n')
    )

  it 'should fix space indentation', ->
    @file.write(
      'line one\n  line two\n    line three\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\n  line two\n    line three\n')
    )

describe 'indent_style/indent_size rule integration (tabs)', ->
  before ->
    @file = new File('./test/fixtures/indent-char-tab/file')
    @rule = new IndentChar('./test/fixtures/indent-char-tab/file')

  after ->
    # reset file state
    @file.write(
      'line one\n\tline two\n\t\tline three\n'
    )

  it 'should detect indentation', ->
    @file.write(
      'line one\n\tline two\n\t\tline three\n'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql('\t')
    )

  it 'should fix tab indentation', ->
    @file.write(
      'line one\n\tline two\n\t\tline three\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\n\tline two\n\t\tline three\n')
    )

  it 'should fix space indentation', ->
    @file.write(
      'line one\n  line two\n    line three\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\n\tline two\n\t\tline three\n')
    )