require('coffee-script')            // switch to coffee-script for specs

global.chai = require('chai')

global.should = chai.should()
global.expect = chai.expect
global.assert = chai.assert

global.Mixin = require('../index')  // load this lib
