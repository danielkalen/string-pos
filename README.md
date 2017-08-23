# string-pos
[![Build Status](https://travis-ci.org/danielkalen/string-pos.svg?branch=master)](https://travis-ci.org/danielkalen/string-pos)
[![Coverage](.config/badges/coverage.png?raw=true)](https://github.com/danielkalen/string-pos)
[![Code Climate](https://codeclimate.com/github/danielkalen/string-pos/badges/gpa.svg)](https://codeclimate.com/github/danielkalen/string-pos)
[![NPM](https://img.shields.io/npm/v/string-pos.svg)](https://npmjs.com/package/string-pos)
[![NPM](https://img.shields.io/npm/dm/string-pos.svg)](https://npmjs.com/package/string-pos)


## Usage
```javascript
var stringPos = require('coffee-register');
var sample = "abc\n\n123\n \ndef";

stringPos(sample, 0) //-> {line:1, column:0}
stringPos(sample, 2) //-> {line:1, column:2}
stringPos(sample, 4) //-> {line:2, column:0}
stringPos(sample, 7) //-> {line:3, column:2}

stringPos.toIndex(sample, {line:1, column:0}) //-> 0
stringPos.toIndex(sample, {line:1, column:2}) //-> 2
stringPos.toIndex(sample, {line:2, column:0}) //-> 4
stringPos.toIndex(sample, {line:3, column:2}) //-> 7
```


## Benchmarks
[![Benchmarks](benchmarks/results.png?raw=true)](https://github.com/danielkalen/string-pos)


## Notes
- Compatible with [source-map](http://ghub.io/source-map) positions.
- Line numbers are 1 index based.
- Column numbers are zero index based.



## License
MIT © [Daniel Kalen](https://github.com/danielkalen)