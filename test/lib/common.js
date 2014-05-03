var chai = require('chai');
var sinon = require('sinon');

chai.use(require('sinon-chai'));

exports.context = {
    report: function (message) {
    }
};

exports.expect = chai.expect;
exports.reporter = sinon.spy(exports.context, 'report');
