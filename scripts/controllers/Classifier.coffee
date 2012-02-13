define (require) ->
	Spine = require 'Spine'

	class Classifier extends Spine.Controller
		model: null
		picker: null

		elements:
			'.details > .latitude': 'latitude'
			'.details > .longitude': 'longitude'
			'.details > .depth': 'depth'

		events:
			'chang .ground-cover input': 'groundCoverChanged'
			'click .ground-cover > .finished': 'finishedGroundCover'
			'click .species button': 'speciesChanged'
			'click .species > .finished': 'finishedSpecies'

		setModel: ->

		groundCoverChanged: ->

		finishedGroundCover: ->

		speciesChanged: ->

		finishedSpecies: ->
