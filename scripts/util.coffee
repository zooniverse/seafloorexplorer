exports =
	delay: (duration, callback) ->
		if typeof duration is 'function'
			callback = duration
			duration = 0

		setTimeout callback, duration

	indexOf: (array, theItem) ->
		array.indexOf?(theItem) or (i for anItem, i in array when anItem is theItem)[0]
