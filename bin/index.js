#!/usr/bin/env node
try {
  require('coffee-script/register');
  // in production, this will fail if coffeescript isn't installed, but the
  // coffee is compiled anyway, so it doesn't matter
} catch(e){}

var cli = require('../lib/cli');
cli.parse(process.argv);
