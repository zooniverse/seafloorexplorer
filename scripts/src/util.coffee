define (require, exports, module) ->
	$ = require 'jQuery'
	translations = require 'translations'

	module.exports =
		delay: (duration, callback) ->
			if typeof duration is 'function'
				callback = duration
				duration = 0

			setTimeout callback, duration

		indexOf: (array, theItem) ->
			array.indexOf?(theItem) or (i for anItem, i in array when anItem is theItem)[0]

		translate: (term, wrap = 'p', className = '') ->
			container = $("<div></div>")

			languages = translations[term]
			for language, parts of languages
				unless parts instanceof Array then parts = [parts]

				for part in parts
					container.append "<#{wrap} lang=\"#{language}\">#{part}</#{wrap}>"

			container.children().addClass className
