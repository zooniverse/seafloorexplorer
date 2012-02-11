define (require) ->
	unless Raphael
		throw new Error 'Raphael needs its own script tag *before* RequireJS.'

	Raphael
