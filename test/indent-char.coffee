require 'should'
File = require 'fobject'

EditorConfigError = require '../lib/editorconfigerror'
IndentChar = require '../lib/rules/indent-char'

describe 'indent_style/indent_size rule unit', ->
  before ->
    (new IndentChar('fakefile')).then((rule) =>
      @rule = rule
    )

  it 'should have the correct propertyName', ->
    @rule.propertyName.should.eql('indent_char')

describe 'indent_style/indent_size rule integration (spaces)', ->
  before ->
    @file = new File('./test/fixtures/indent-char-space/file')
    (new IndentChar('./test/fixtures/indent-char-space/file')).then((rule) =>
      @rule = rule
    )

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
    (new IndentChar('./test/fixtures/indent-char-tab/file')).then((rule) =>
      @rule = rule
    )

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

describe 'indent_style/indent_size rule integration (null)', ->
  before ->
    @file = new File('./test/fixtures/indent-char-null/file')
    (new IndentChar('./test/fixtures/indent-char-null/file')).then((rule) =>
      @rule = rule
    )

  after ->
    # reset file state
    @file.write(
      'line one\n  line two\n    line three\n'
    )

  it 'should throw error and not change the file', ->
    @file.write(
      'line one\n  line two\n    line three\n'
    ).then(
      @rule.fix
    ).catch((e) ->
      e.should.eql(
        new EditorConfigError('cannot fix indent_char (no setting defined)')
      )
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line one\n  line two\n    line three\n')
    )
