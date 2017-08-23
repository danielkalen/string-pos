var Benchmark, Promise, benchmarks, chalk, findLineColumn, i, lineColumn, linesAndColumns, shuffle, stringPos, suite, target, text;

Promise = require('bluebird');

Benchmark = require('benchmark');

benchmarks = require('beautify-benchmark');

chalk = require('chalk');

shuffle = require('array-shuffle');

text = Object.create(null);

text.short = 'Lorem ipsum dolor sit amet\nconsectetur adipiscing elit.\nSuspendisse id sem vel mi cursus facilisis vel ac arcu.\nNulla vulputate tortor eu ipsum bibendum rhoncus';

text.medium = ((function() {
  var j, results;
  results = [];
  for (i = j = 1; j <= 10; i = ++j) {
    results.push(shuffle(text.short.split('\n')));
  }
  return results;
})()).join('\n');

text.long = ((function() {
  var j, results;
  results = [];
  for (i = j = 1; j <= 200; i = ++j) {
    results.push(shuffle(text.short.split('\n')));
  }
  return results;
})()).join('\n');

target = Object.create(null);

target.short = Math.round(text.short.length / 2 + ((text.short.length / 2) * 0.34));

target.medium = Math.round(text.medium.length / 2 + ((text.medium.length / 2) * 0.34));

target.long = Math.round(text.long.length / 2 + ((text.long.length / 2) * 0.34));

stringPos = require('../');

findLineColumn = require('find-line-column');

lineColumn = require('line-column');

linesAndColumns = require('lines-and-columns')["default"];

suite = function(name, options) {
  return Benchmark.Suite(name, options).on('start', function() {
    return console.log(chalk.dim(name));
  }).on('cycle', function() {
    return benchmarks.add(arguments[0].target);
  }).on('complete', function() {
    return benchmarks.log();
  });
};

suite('short text').add('find-line-column', function() {
  return findLineColumn(text.short, target.short);
}).add('lines-and-columns', function() {
  return (new linesAndColumns(text.short)).locationForIndex(target.short);
}).add('line-column', function() {
  return lineColumn(text.short).fromIndex(target.short);
}).add('string-pos', function() {
  return stringPos(text.short, target.short);
}).run();

suite('medium text').add('find-line-column', function() {
  return findLineColumn(text.medium, target.medium);
}).add('lines-and-columns', function() {
  return (new linesAndColumns(text.medium)).locationForIndex(target.medium);
}).add('line-column', function() {
  return lineColumn(text.medium).fromIndex(target.medium);
}).add('string-pos', function() {
  return stringPos(text.medium, target.medium);
}).run();

suite('long text').add('find-line-column', function() {
  return findLineColumn(text.long, target.long);
}).add('lines-and-columns', function() {
  return (new linesAndColumns(text.long)).locationForIndex(target.long);
}).add('line-column', function() {
  return lineColumn(text.long).fromIndex(target.long);
}).add('string-pos', function() {
  return stringPos(text.long, target.long);
}).run();
