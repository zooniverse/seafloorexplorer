Spine = require 'Spine'
$ = require 'jQuery'

Subject = require 'models/Subject'
GroundCover = require 'models/GroundCover'

class Classifier extends Spine.Controller
	subject: null
	classification: null

	picker: null

	elements:
		'.position > .latitude': 'latitude'
		'.position > .longitude': 'longitude'
		'.depth > .meters': 'depth'
		'.steps': 'steps'
		'.ground-cover.step': 'groundCoverStep'
		'.ground-cover.toggles': 'groundCoverList'
		'.ground-cover .finished': 'groundCoverFinishedButton'
		'.species.step': 'speciesStep'
		'.species.toggles button': 'speciesButtons'
		'.species .delete': 'deleteButton'
		'.species .finished': 'speciesFinishedButton'
		'.summary .total': 'total'

	events:
		'click .ground-cover.toggles button': 'toggleGroundCover'
		'click .ground-cover .finished': 'finishGroundCover'
		'click .species.toggles button': 'changeSpecies'
		'click .species .delete': 'deleteSelected'
		'click .species > .finished': 'finishSpecies'
		'click .next': 'nextSubject'

	constructor: ->
		super
		@changeSubject @subject
		@picker.bind 'change-selection', @render
		for groundCover in GroundCover.all()
			@groundCoverList.append """
				<li>
					<button value="#{groundCover.id}">#{groundCover.description}</button>
				</li>
			"""

	changeSubject: (@subject) =>
		@steps.removeClass 'finished'
		@groundCoverStep.removeClass 'finished'
		@groundCoverStep.addClass 'active'
		@speciesStep.removeClass 'active'
		@changeSpecies null

		@latitude.html @subject.latitude
		@longitude.html @subject.longitude
		@depth.html @subject.depth
		@picker.img.attr 'src', @subject.image

		@classification = @subject.classifications().create {}
		@picker.changeClassification @classification

		@classification.bind 'change', @render
		@classification.trigger 'change'

	render: =>
		for button in @groundCoverList.find 'button'
			button = $(button)

			# Is .groundCovers().findByAttribute broken?
			groundCovers = @classification.groundCovers().all()
			groundCover = (gc for gc in groundCovers when gc.ground_cover_id is button.val())[0]

			if groundCover
				button.addClass 'active'
			else
				button.removeClass 'active'

		@groundCoverFinishedButton.attr 'disabled', @classification.groundCovers().all().length is 0

		selectedMarker = (m for m in @picker.markers when m.selected)[0]
		if selectedMarker
			@speciesButtons.removeClass 'active'
			@speciesButtons.filter("[value='#{selectedMarker.marking.species}']").addClass 'active'

		@speciesButtons.find('.count').html '0'
		for marking in @classification.markings().all()
			button = @speciesButtons.filter "[value='#{marking.species}']"
			countElement = button.find '.count'
			countElement.html parseInt(countElement.html(), 10) + 1

		@deleteButton.attr 'disabled', not selectedMarker

		@total.html @classification.markings().all().length

	toggleGroundCover: (e) =>
		target = $(e.target)

		groundCovers = @classification.groundCovers().all()
		groundCover = (gc for gc in groundCovers when gc.ground_cover_id is target.val())[0]

		if groundCover
			groundCover.destroy()
		else
			@classification.groundCovers().create ground_cover_id: target.val()

		@classification.trigger 'change'

	finishGroundCover: =>
		@groundCoverStep.addClass 'finished'
		@groundCoverStep.removeClass 'active'
		@speciesStep.addClass 'active'

	changeSpecies: (e) =>
		e ?= target: $('<input value="" />') # Dummy for when we deselect a button

		target = $(e.target)
		species = target.val()

		@picker.selectedSpecies = species
		@picker.setDisabled not species

		@speciesButtons.removeClass 'active'
		target.addClass 'active'

	deleteSelected: =>
		index = i for marking, i in @picker.markers when marking.selected
		@picker.markers[index].marking.destroy()
		@classification.trigger 'change'

	finishSpecies: =>
		@picker.setDisabled true

		species = {}
		for marking in @picker.markers
			species[marking.type] ||= []
			species[marking.type].push marking.points

		@classification.updateAttribute 'species', species

		@steps.addClass 'finished'

	nextSubject: =>
		@classification.save()

		nextSubject = Subject.next()

		if nextSubject
			@changeSubject nextSubject
		else
			@noMoreSubjects()

	noMoreSubjects: =>
		alert 'No more subjects to classify!'

exports = Classifier
