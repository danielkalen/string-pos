var Cache, memoize, parse, toIndex, toPos;

Cache = (function() {
  function Cache() {
    this.keys = [];
    this.values = [];
    this.length = 0;
  }

  Cache.prototype.get = function(key) {
    var i, len;
    i = -1;
    len = this.length;
    while (++i < len) {
      if (key === this.keys[i]) {
        return this.values[i];
      }
    }
  };

  Cache.prototype.set = function(key, value) {
    this.keys.push(key);
    this.length = this.values.push(value);
    return value;
  };

  return Cache;

})();

memoize = function(fn) {
  var cache;
  cache = new Cache;
  return function(arg) {
    var cached;
    cached = cache.get(arg);
    if (typeof cached !== 'undefined') {
      return cached;
    } else {
      return cache.set(arg, fn(arg));
    }
  };
};

parse = memoize(function(string) {
  var index, j, len1, line, offset, offsets, output, ref;
  output = Object.create(null);
  output.string = string || '';
  output.lines = output.string.split('\n');
  output.offsets = offsets = [0];
  ref = output.lines;
  for (index = j = 0, len1 = ref.length; j < len1; index = ++j) {
    line = ref[index];
    offset = line.length + (offsets[index] + 1);
    if (offset < string.length) {
      offsets.push(offset);
    }
  }
  return output;
});

toPos = function(string, index) {
  var max, mid, min, parsed;
  if (index <= 0) {
    return {
      line: 1,
      column: 0
    };
  }
  parsed = parse(string);
  min = 0;
  max = parsed.offsets.length - 1;
  while (min < max) {
    mid = min + Math.floor(max / 2 - min / 2);
    if (index < parsed.offsets[mid]) {
      max = mid - 1;
    } else if (index >= parsed.offsets[mid + 1]) {
      min = mid + 1;
    } else {
      min = mid;
      break;
    }
  }
  return {
    line: min + 1,
    column: index - parsed.offsets[min]
  };
};

toIndex = function(string, pos) {
  var parsed, result;
  result = 0;
  if (pos.line <= 0 || (pos.line === 1 && pos.column === 0)) {
    return result;
  }
  parsed = parse(string);
  if (pos.line >= parsed.offsets.length) {
    return string.length - 1;
  }
  result += parsed.offsets[pos.line - 1];
  result += pos.column < 0 ? pos.column * -1 : pos.column;
  return result;
};

module.exports = toPos;

module.exports.toIndex = toIndex;
