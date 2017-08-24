Promise = require 'bluebird'
promiseBreak = require 'promise-break'
execa = require 'execa'
chalk = require 'chalk'
path = require 'path'
fs = require 'fs-jetpack'
CACHE_DIR = path.resolve '.config','buildcache'
modules = 
	build: ['string-hash']
	benchmarks: ['array-shuffle','benchmark','beautify-benchmark','find-line-column','line-column','lines-and-columns']
	coverage: ['badge-gen','coffee-coverage','istanbul','coffee-register']
	test: ['mocha','chai','coffee-register']


task 'build', 'compile lib, test, and benchmark files', ()->
	Promise.resolve()
		.then ()-> invoke 'build:lib'
		.then ()-> invoke 'build:benchmarks'

task 'build:lib', ()->
	compileCoffee 'lib/index.coffee', 'lib/index.js', 'build'

task 'build:benchmarks', ()->
	compileCoffee 'benchmarks/runner.coffee', 'benchmarks/runner.js', 'benchmarks'



task 'install', ()->
	Promise.mapSeries Object.keys(modules), (target)-> install(target)

task 'install:test', ()->
	install 'test'

task 'install:coverage', ()->
	install 'coverage'

task 'install:benchmarks', ()->
	install 'benchmarks'



compileCoffee = (srcFile, destFile, installTarget)->
	Promise.resolve()
		.then ()-> install 'build'
		.then ()-> install installTarget
		.then ()-> fs.dirAsync(CACHE_DIR)
		.then ()-> fs.readAsync(srcFile)
		.then (src)->
			srcHash = require('string-hash')(src)
			cacheDest = path.join(CACHE_DIR, "#{srcHash}.js")
			
			Promise.resolve()
				.then ()-> fs.existsAsync(cacheDest)
				.then (cacheExists)-> promiseBreak() if cacheExists
				.then ()-> console.log "Building #{srcFile}"
				.then ()-> require('coffee-script').compile src, {bare:true}
				.then (output)-> fs.writeAsync cacheDest, output
				.catch promiseBreak.end
				.then ()-> fs.copyAsync cacheDest, destFile, overwrite:true


install = (target)->
	Promise.resolve()
		.then ()-> modules[target].filter (module)-> not moduleInstalled(module)
		.tap (missingModules)-> promiseBreak() if missingModules.length is 0
		.tap (missingModules)-> installModules(missingModules)
		.catch promiseBreak.end

installModules = (targetModules)->
	targetModules = targetModules
		.filter (module)-> if typeof module is 'string' then true else module[1]()
		.map (module)-> if typeof module is 'string' then module else module[0]
	
	return if not targetModules.length
	console.log "#{chalk.yellow('Installing')} #{chalk.dim targetModules.join ', '}"
	
	execa('npm', ['install', '--no-save', '--no-purne', targetModules...], {stdio:'inherit'})


moduleInstalled = (targetModule)->
	targetModule = targetModule[0] if typeof targetModule is 'object'
	if (split=targetModule.split('@')) and split[0].length
		targetModule = split[0]
		targetVersion = split[1]

	if /^github:.+?\//.test(targetModule)
		targetModule = targetModule.replace /^github:.+?\//, ''
	
	pkgFile = path.resolve('node_modules',targetModule,'package.json')
	exists = fs.exists(pkgFile)
	
	if exists and targetVersion?
		currentVersion = fs.read(pkgFile, 'json').version
		exists = require('semver').gte(currentVersion, targetVersion)

	return exists












