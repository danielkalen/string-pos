class Cache
	constructor: ()->
		@keys = []
		@values = []
		@length = 0;

	get: (key)->
		i = -1; len = @length
		while ++i < len
			return @values[i] if key is @keys[i]
	
	set: (key,value)->
		@keys.push(key)
		@length = @values.push(value)
		return value

# serialize = (target)->
# 	if target and typeof target is 'object'
# 		return "line:#{target.line} column:#{target.column}"
	
# 	return target

# memoize = (fn)->
# 	cache = new Cache

# 	return (a,b)->
# 		serialized = if typeof b is 'undefined' then a else a+'-,-'+serialize(b)
# 		cached = cache.get(serialized)

# 		if typeof cached isnt 'undefined'
# 			return cached
# 		else
# 			return cache.set(serialized, fn(a,b))

memoize = (fn)->
	cache = new Cache

	return (arg)->
		cached = cache.get(arg)

		if typeof cached isnt 'undefined'
			return cached
		else
			return cache.set(arg, fn(arg))



parse = memoize (string)->
	output = Object.create(null)
	output.string = string or ''
	output.lines = output.string.split '\n'
	output.offsets = offsets = [0]

	for line,index in output.lines
		offset = line.length + (offsets[index]+1)
		offsets.push(offset) if offset < string.length

	return output


toPos = (string, index)->
	return {line:1, column:0} if index <= 0
	parsed = parse(string)
	
	min = 0; max = parsed.offsets.length-1
	while min < max
		mid = min + Math.floor(max/2 - min/2)

		if index < parsed.offsets[mid]
			max = mid - 1
		else if index >= parsed.offsets[mid + 1]
			min = mid + 1
		else
			min = mid
			break

	return {
		line: min+1
		column: index - parsed.offsets[min]
	}


toIndex = (string, pos)->
	result = 0
	return result if pos.line <= 0 or (pos.line is 1 and pos.column is 0)
	parsed = parse(string)
	
	if pos.line >= parsed.offsets.length
		return string.length-1

	result += parsed.offsets[pos.line-1]
	result += if pos.column < 0 then pos.column * -1 else pos.column
	return result





module.exports = toPos
module.exports.toIndex = toIndex










