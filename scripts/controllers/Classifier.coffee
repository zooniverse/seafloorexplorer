define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'

	class Classifier extends Spine.Controller
		subject: null
		picker: null

		elements:
			'.position > .latitude': 'latitude'
			'.position > .longitude': 'longitude'
			'.depth > .meters': 'depth'
			'.steps': 'steps'
			'.ground-cover.step': 'groundCoverStep'
			'.ground-cover.toggles button': 'groundCoverButtons'
			'.ground-cover .finished': 'groundCoverFinishedButton'
			'.species.step': 'speciesStep'
			'.species.toggles button': 'speciesButtons'
			'.species .delete': 'deleteButton'
			'.species .finished': 'speciesFinishedButton'
			'.summary .total': 'total'

		events:
			'click .ground-cover.toggles button': 'changeGroundCover'
			'click .ground-cover .finished': 'finishGroundCover'
			'click .species.toggles button': 'changeSpecies'
			'click .species .delete': 'deleteSelected'
			'click .species > .finished': 'finishSpecies'
			'click .next': 'nextSubject'

		constructor: ->
			super

			@setSubject @subject
			@reset()
			@render()

		setSubject: (@subject) =>
			@picker.setSubject @subject
			@subject.bind 'change', @render

		reset: =>
			@picker.reset()
			@picker.setDisabled true

			@steps.removeClass 'finished'
			@groundCoverStep.removeClass 'finished'
			@groundCoverStep.addClass 'active'
			@speciesStep.removeClass 'active'
			@speciesButtons.first().click()

		render: =>
			@latitude.html @subject.latitude
			@longitude.html @subject.longitude
			@depth.html @subject.depth

			@groundCoverButtons.removeClass 'active'
			@groundCoverButtons.filter("[value='#{@subject.groundCover}']").addClass 'active'

			@groundCoverFinishedButton.attr 'disabled', not @subject.groundCover

			@speciesButtons.find('.count').html '0'
			for marking in @subject.markings().all() when marking.species
				button = @speciesButtons.filter "[value='#{marking.species}']"
				countContainer = button.find '.count'
				countContainer.html parseInt(countContainer.html(), 10) + 1

			anythingActive = (m for m in @picker.markings when m.active).length isnt 0
			@deleteButton.attr 'disabled', not anythingActive

			@total.html @subject.markings().all().length

		changeGroundCover: (e) =>
			@subject.updateAttribute 'groundCover', e.target.value

		finishGroundCover: =>
			@groundCoverStep.addClass 'finished'
			@groundCoverStep.removeClass 'active'
			@speciesStep.addClass 'active'
			@picker.setDisabled false

		changeSpecies: (e) =>
			target = $(e.target)
			species = target.val()

			@picker.selectedSpecies = species

			@speciesButtons.removeClass 'active'
			target.addClass 'active'

			for marking in @picker.markings when marking.active
				marking.model.updateAttribute 'species', species

		deleteSelected: =>
			marking.model.destroy() for marking in @picker.markings when marking.active

		finishSpecies: =>
			@picker.setDisabled true

			species = {}
			for marking in @picker.markings
				species[marking.type] ||= []
				species[marking.type].push marking.points

			@subject.updateAttribute 'species', species

			@steps.addClass 'finished'

		nextSubject: =>
			@setSubject @subject #TODO
			@reset()
			@render()
