define (require) ->
	Spine = require 'Spine'

	class Classifier extends Spine.Controller
		subject: null
		picker: null

		elements:
			'.details > .position > .latitude': 'latitude'
			'.details > .position > .longitude': 'longitude'
			'.details > .depth > .meters': 'depth'
			'input[name="ground-cover"]': 'groundCoverRadios'
			'input[name="species"]': 'speciesRadios'

		events:
			'change input[name="ground-cover"]': 'groundCoverChanged'
			'click .ground-cover .finished': 'finishedGroundCover'
			'change input[name="species"]': 'speciesChanged'
			'click .species > .finished': 'finishedSpecies'

		constructor: ->
			super
			if @subject then @setSubject @subject

		setSubject: (@subject) =>
			@reset()

			@picker.setImgSrc @subject.src
			@latitude.html @subject.latitude
			@longitude.html @subject.longitude
			@depth.html @subject.depth

		groundCoverChanged: (e) =>
			@log 'Ground cover changed', e.target.value

		finishedGroundCover: =>
			@log 'Finished ground cover'
			Spine.Route.navigate '/classify/species', true

		speciesChanged: (e) =>
			@log 'Species changed', e.target.value

		finishedSpecies: =>
			# Save the model, show the "receipt"

		reset: =>
			@picker.reset()
			@groundCoverRadios.each -> @checked = false
			@speciesRadios.each -> @checked = false
