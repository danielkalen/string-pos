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

# for fair comparison load indexes and warm caches
stringPos(text.short, 0)
stringPos(text.medium, 0)
stringPos(text.long, 0)
lineColumnShort = lineColumn(text.short)
lineColumnMedium = lineColumn(text.medium)
lineColumnLong = lineColumn(text.long)
linesAndColumnsShort = (new linesAndColumns text.short)
linesAndColumnsMedium = (new linesAndColumns text.medium)
linesAndColumnsLong = (new linesAndColumns text.long)

suite = (name, options)->
	Benchmark.Suite(name, options)
		.on 'start', ()-> console.log chalk.dim name
		.on 'cycle', ()-> benchmarks.add arguments[0].target
		.on 'complete', ()-> benchmarks.log()

suite('short text')
	.add 'find-line-column', ()->
		findLineColumn(text.short, target.short)
	
	.add 'lines-and-columns', ()->
		linesAndColumnsShort.locationForIndex(target.short)
	
	.add 'line-column', ()->
		lineColumnShort.fromIndex(target.short)

	.add 'string-pos', ()->
		stringPos(text.short, target.short)
	
	.run()


suite('medium text')
	.add 'find-line-column', ()->
		findLineColumn(text.medium, target.medium)
	
	.add 'lines-and-columns', ()->
		linesAndColumnsMedium.locationForIndex(target.medium)
	
	.add 'line-column', ()->
		lineColumnMedium.fromIndex(target.medium)

	.add 'string-pos', ()->
		stringPos(text.medium, target.medium)
	
	.run()


suite('long text')
	.add 'find-line-column', ()->
		findLineColumn(text.long, target.long)
	
	.add 'lines-and-columns', ()->
		linesAndColumnsLong.locationForIndex(target.long)
	
	.add 'line-column', ()->
		lineColumnLong.fromIndex(target.long)

	.add 'string-pos', ()->
		stringPos(text.long, target.long)
	
	.run()






