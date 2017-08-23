Promise = require 'bluebird'
Benchmark = require 'benchmark'
benchmarks = require 'beautify-benchmark'
chalk = require 'chalk'
shuffle = require 'array-shuffle'


text = Object.create(null)
text.short = 'Lorem ipsum dolor sit amet\nconsectetur adipiscing elit.\nSuspendisse id sem vel mi cursus facilisis vel ac arcu.\nNulla vulputate tortor eu ipsum bibendum rhoncus'
text.medium = (shuffle(text.short.split('\n')) for i in [1..10]).join('\n')
text.long = (shuffle(text.short.split('\n')) for i in [1..200]).join('\n')

target = Object.create(null)
target.short = Math.round text.short.length/2+((text.short.length/2)*0.34)
target.medium = Math.round text.medium.length/2+((text.medium.length/2)*0.34)
target.long = Math.round text.long.length/2+((text.long.length/2)*0.34)

stringPos = require '../'
findLineColumn = require 'find-line-column'
lineColumn = require 'line-column'
linesAndColumns = require('lines-and-columns').default

suite = (name, options)->
	Benchmark.Suite(name, options)
		.on 'start', ()-> console.log chalk.dim name
		.on 'cycle', ()-> benchmarks.add arguments[0].target
		.on 'complete', ()-> benchmarks.log()

suite('short text')
	.add 'find-line-column', ()->
		findLineColumn(text.short, target.short)
	
	.add 'lines-and-columns', ()->
		(new linesAndColumns text.short).locationForIndex(target.short)
	
	.add 'line-column', ()->
		lineColumn(text.short).fromIndex(target.short)

	.add 'string-pos', ()->
		stringPos(text.short, target.short)
	
	.run()


suite('medium text')
	.add 'find-line-column', ()->
		findLineColumn(text.medium, target.medium)
	
	.add 'lines-and-columns', ()->
		(new linesAndColumns text.medium).locationForIndex(target.medium)
	
	.add 'line-column', ()->
		lineColumn(text.medium).fromIndex(target.medium)

	.add 'string-pos', ()->
		stringPos(text.medium, target.medium)
	
	.run()


suite('long text')
	.add 'find-line-column', ()->
		findLineColumn(text.long, target.long)
	
	.add 'lines-and-columns', ()->
		(new linesAndColumns text.long).locationForIndex(target.long)
	
	.add 'line-column', ()->
		lineColumn(text.long).fromIndex(target.long)

	.add 'string-pos', ()->
		stringPos(text.long, target.long)
	
	.run()






