path = require 'path'
mocha = require 'mocha'
chai = require 'chai'
{expect} = chai
stringPos = require('../')


suite "string-pos", ()->
	suiteSetup ()->
		# @string = "abc\n\n123\n \ndef\n456"
		@string = """
			abc

			123
			 
			def
			456
		"""

	test "index to pos", ()->
		expect(stringPos @string, 0).to.eql {line:1, column:0}
		expect(stringPos @string, 0).to.eql {line:1, column:0}
		expect(stringPos @string, 2).to.eql {line:1, column:2}
		expect(stringPos @string, 4).to.eql {line:2, column:0}
		expect(stringPos @string, 5).to.eql {line:3, column:0}
		expect(stringPos @string, 6).to.eql {line:3, column:1}
		expect(stringPos @string, 7).to.eql {line:3, column:2}
		expect(stringPos @string, 8).to.eql {line:3, column:3}
		expect(stringPos @string, 9).to.eql {line:4, column:0}
		expect(stringPos @string, 10).to.eql {line:4, column:1}
		expect(stringPos @string, @string.length).to.eql {line:6, column:3}
		expect(stringPos @string, @string.length*2).to.eql {line:6, column:21}
		expect(stringPos @string, -9).to.eql {line:1, column:0}

	test "pos to index", ()->
		expect(stringPos.toIndex @string, {line:1, column:0}).to.equal 0
		expect(stringPos.toIndex @string, {line:1, column:0}).to.equal 0
		expect(stringPos.toIndex @string, {line:1, column:2}).to.equal 2
		expect(stringPos.toIndex @string, {line:2, column:0}).to.equal 4
		expect(stringPos.toIndex @string, {line:3, column:0}).to.equal 5
		expect(stringPos.toIndex @string, {line:3, column:1}).to.equal 6
		expect(stringPos.toIndex @string, {line:3, column:2}).to.equal 7
		expect(stringPos.toIndex @string, {line:3, column:3}).to.equal 8
		expect(stringPos.toIndex @string, {line:4, column:0}).to.equal 9
		expect(stringPos.toIndex @string, {line:4, column:1}).to.equal 10
		expect(stringPos.toIndex @string, {line:6, column:3}).to.equal @string.length-1
		expect(stringPos.toIndex @string, {line:6, column:21}).to.equal @string.length-1
		expect(stringPos.toIndex @string, {line:0, column:21}).to.equal 0
		expect(stringPos.toIndex @string, {line:-5, column:21}).to.equal 0
