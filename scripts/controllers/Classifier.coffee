Spine = require 'Spine'
$ = require 'jQuery'

Subject = require 'models/Subject'

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
		@changeSubject @subject
		@picker.bind 'changed-selection', @render

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
		console.log 'New classification', @classification, @classification.id
		@picker.changeClassification @classification

		@classification.bind 'change', @render
		@classification.trigger 'change'

	render: =>
		activeMarker = (m for m in @picker.markers when m.active)[0]

		@groundCoverButtons.removeClass 'active'
		@groundCoverButtons.filter("[value='#{@classification.groundCover}']").addClass 'active'
		@groundCoverFinishedButton.attr 'disabled', not @classification.groundCover

		if activeMarker
			@speciesButtons.removeClass 'active'
			@speciesButtons.filter("[value='#{activeMarker.marking.species}']").addClass 'active'

		@speciesButtons.find('.count').html '0'
		for marking in @classification.markings().all()
			button = @speciesButtons.filter "[value='#{marking.species}']"
			countElement = button.find '.count'
			countElement.html parseInt(countElement.html(), 10) + 1

		@deleteButton.attr 'disabled', not activeMarker

		@total.html @classification.markings().all().length

	changeGroundCover: (e) =>
		@classification.updateAttribute 'groundCover', e.target.value

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
		index = i for marking, i in @picker.markers when marking.active
		@picker.markers[index].marking.destroy()

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
