require 'should'
File = require 'fobject'

InsertFinalNewline = require '../lib/rules/insert-final-newline'

describe 'insert_final_newline rule unit', ->
  before ->
    @rule = new InsertFinalNewline('fakefile')
    (new InsertFinalNewline('fakefile')).then((rule) =>
      @rule = rule
    )

  it 'should have the correct propertyName', ->
    @rule.propertyName.should.eql('insert_final_newline')

describe 'insert_final_newline rule integration (true)', ->
  before ->
    @file = new File('./test/fixtures/insert-final-newline-true/file')
    @file.write(
      'line\n'
    ).then( ->
      new InsertFinalNewline('./test/fixtures/insert-final-newline-true/file')
    ).then((rule) =>
      @rule = rule
    )

  after ->
    # reset file state
    @file.write(
      'line\n'
    )

  it 'should detect line ending', ->
    @file.write(
      'line\n'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql(true)
    )

  it 'shouldn\'t add a newline to empty files', ->
    @file.write(
      ''
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('')
    )

  it 'should fix missing line ending', ->
    @file.write(
      'line'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line\n')
    )

  it 'should fix present line ending', ->
    @file.write(
      'line\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line\n')
    )

describe 'insert_final_newline rule integration (false)', ->
  before ->
    @file = new File('./test/fixtures/insert-final-newline-false/file')
    (
      new InsertFinalNewline('./test/fixtures/insert-final-newline-false/file')
    ).then((rule) =>
      @rule = rule
    )

  after ->
    # reset file state
    @file.write('line')

  it 'should detect missing line ending', ->
    @file.write(
      'line'
    ).then(
      @rule.infer
    ).then((res) ->
      res.should.eql(false)
    )

  it 'should fix missing line ending', ->
    @file.write(
      'line'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line')
    )

  it 'should fix present line ending', ->
    @file.write(
      'line\n'
    ).then(
      @rule.fix
    ).then( =>
      @file.read(encoding: 'utf8')
    ).then((res) ->
      res.should.eql('line')
    )
