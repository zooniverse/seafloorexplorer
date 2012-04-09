$ = require 'jQuery'
translations = require 'translations'

exports =
	delay: (duration, callback) ->
		if typeof duration is 'function'
			callback = duration
			duration = 0

		setTimeout callback, duration

	indexOf: (array, theItem) ->
		array.indexOf?(theItem) or (i for anItem, i in array when anItem is theItem)[0]

	offsetOf: (selector, horizontal = 'left', vertical = 'top') ->
		selection = $(selector).first()
		offset = selection.offset()

		if horizontal isnt 'left'
			width = selection.width()
			if horizontal is 'center' then offset.left += width / 2
			if horizontal is 'right' then offset.left += width

		if vertical isnt 'top'
			height = selection.height()
			if vertical is 'middle' then offset.top += height / 2
			if vertical is 'bottom' then offset.top += height

		offset

	translate: (term, wrap = 'p', className = '') ->
		container = $("<div></div>")

		languages = translations[term]
		for language, parts of languages
			unless parts instanceof Array then parts = [parts]

			for part in parts
				container.append "<#{wrap} lang=\"#{language}\">#{part}</#{wrap}>"

		container.children().addClass className
