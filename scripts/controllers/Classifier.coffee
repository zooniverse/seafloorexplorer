Spine = require 'Spine'
$ = require 'jQuery'

CreaturePicker = require 'controllers/CreaturePicker'
Pager = require 'controllers/Pager'

Subject = require 'models/Subject'
GroundCover = require 'models/GroundCover'

TEMPLATE = require 'lib/text!views/Classifier.html'

class Classifier extends Spine.Controller
	subject: null
	classification: null

	picker: null
	template: TEMPLATE

	elements:
		'.steps': 'steps'
		'.ground-cover .toggles': 'groundCoverList'
		'.ground-cover .finished': 'groundCoverFinishedButton'
		'.species .toggles button': 'speciesButtons'
		'.species .finished': 'speciesFinishedButton'
		'.summary': 'summary'
		'.summary .total': 'total'

	events:
		'click .ground-cover .toggles button': 'toggleGroundCover'
		'click .ground-cover .finished': 'finishGroundCover'
		'click .species .toggles button': 'changeSpecies'
		'click .species .finished': 'finishSpecies'
		'click .talk .yes': 'goToTalk'
		'click .talk .no': 'nextSubject'

	constructor: ->
		super

		@html @template

		@picker = new CreaturePicker
			el: @el.find '.image'

		new Pager el: parent for parent in @el.find('[data-page]').parent()

		@changeSubject @subject

		@picker.bind 'change-selection', @render

		for groundCover in GroundCover.all()
			@groundCoverList.append """
				<li>
					<button value="#{groundCover.id}">#{groundCover.description}</button>
				</li>
			"""

	changeSubject: (@subject) =>
		@changeSpecies null

		@classification = @subject.classifications().create {}

		@picker.image.attr 'src', @subject.image
		@picker.changeClassification @classification

		@classification.bind 'change', @render
		@classification.trigger 'change'

		location.hash = '#/classify/ground-cover'
		@steps.removeClass 'finished'

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

		groundCoverPicked = @classification.groundCovers().all().length isnt 0
		@groundCoverFinishedButton.attr 'disabled', not groundCoverPicked
		@speciesFinishedButton.attr 'disabled', not groundCoverPicked

		selectedMarker = (m for m in @picker.markers when m.selected)[0]
		if selectedMarker
			@speciesButtons.removeClass 'active'
			@speciesButtons.filter("[value='#{selectedMarker.marking.species}']").addClass 'active'

		@speciesButtons.find('.count').html '0'
		for marking in @classification.markings().all()
			button = @speciesButtons.filter "[value='#{marking.species}']"
			countElement = button.find '.count'
			countElement.html parseInt(countElement.html(), 10) + 1

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
		location.hash = '#/classify/species'

	changeSpecies: (e) =>
		e ?= target: $('<input value="" />') # Dummy for when we deselect a button

		target = $(e.target)
		species = target.val()

		@picker.selectedSpecies = species
		@picker.setDisabled not species

		@speciesButtons.removeClass 'active'
		target.addClass 'active'

	finishSpecies: =>
		@picker.setDisabled true
		@steps.addClass 'finished'

		# TODO: Update summary

	goToTalk: =>
		alert 'TODO: Go to talk'

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
