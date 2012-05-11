Spine = require 'Spine'
$ = require 'jQuery'

CreaturePicker = require 'controllers/CreaturePicker'
MarkerIndicator = require 'controllers/MarkerIndicator'
Pager = require 'lib/Pager'

User = require 'models/User'
Subject = require 'models/Subject'
Classification = require 'models/Classification'
GroundCover = require 'models/GroundCover'

TEMPLATE = require 'lib/text!views/Classifier.html'

class Classifier extends Spine.Controller
  subject: null
  classification: null

  picker: null
  indicator: null

  template: TEMPLATE

  elements:
    '.steps': 'steps'
    '.ground-cover .toggles': 'groundCoverList'
    '.ground-cover .finished': 'groundCoverFinishedButton'
    '.species .toggles button': 'speciesButtons'
    '.species .other-creatures [value="yes"]': 'otherYes'
    '.species .other-creatures [value="no"]': 'otherNo'
    '.species .finished': 'speciesFinishedButton'
    '.summary .thumbnail img': 'thumbnail'
    '.summary table.ground-cover tbody': 'summaryGroundCoverTable'
    '.summary table.species tbody': 'summarySpeciesTable'

  events:
    'click .steps nav a': (e) -> e.preventDefault()
    'click .ground-cover .toggles button': 'toggleGroundCover'
    'click .ground-cover .finished': 'finishGroundCover'
    'click .species .toggles button': 'changeSpecies'
    'click .species .other-creatures button': 'changeOther'
    'click .species .finished': 'finishSpecies'
    'click .thumbnail img': 'toggleMap'
    'click .toggle-map': 'toggleMap'
    'click .talk .yes': 'goToTalk'
    'click .talk .no': 'nextSubject'

  constructor: ->
    super

    User.bind 'sign-in', @newClassification
    Subject.bind 'change-current', @changeSubject

    @html @template

    @indicator = new MarkerIndicator
      el: @el.find '.indicator'

    @picker = new CreaturePicker
      el: @el.find '.image'
      indicator: @indicator

    @picker.bind 'change-selection', @render

    new Pager el: parent for parent in @el.find('[data-page]').parent()

    for groundCover in GroundCover.all()
      @groundCoverList.append """
        <li>
          <button value="#{groundCover.id}">#{groundCover.description}</button>
        </li>
      """

  newClassification: =>
    @classification?.destroy()
    @classification = User.current?.classifications().create subject: @subject
    @classification ||= new Classification subject: @subject

    @picker.changeClassification @classification

    @classification.bind 'change', @render
    @classification.trigger 'change'

  changeSubject: (@subject) =>
    @newClassification()

    @el.toggleClass 'show-map', false

    @changeSpecies null

    @thumbnail.attr 'src', @subject.image
    @picker.map.attr 'src', "http://maps.googleapis.com/maps/api/staticmap?center=#{@subject.latitude},#{@subject.longitude}&zoom=10&size=745x570&maptype=satellite&sensor=false"
    @picker.image.attr 'src', @subject.image
    @picker.changeClassification @classification

    @steps.removeClass 'finished'
    if ~location.hash.indexOf '/classify'
      location.hash = '#/classify/ground-cover'

  render: =>
    for button in @groundCoverList.find 'button'
      button = $(button)

      # Is @classification.groundCovers().findByAttribute broken?
      groundCovers = @classification.groundCovers().all()
      groundCover = (gc for gc in groundCovers when gc.ground_cover_id is button.val())[0]

      if groundCover
        button.addClass 'active'
      else
        button.removeClass 'active'

    groundCoverPicked = @classification.groundCovers().all().length isnt 0
    @groundCoverFinishedButton.attr 'disabled', not groundCoverPicked

    selectedMarker = (m for m in @picker.markers when m.selected)[0]
    if selectedMarker
      @speciesButtons.filter("[value='#{selectedMarker.marking.species}']").trigger 'click'

    @speciesButtons.find('.count').html '0'
    for marking in @classification.markings().all()
      button = @speciesButtons.filter "[value='#{marking.species}']"
      countElement = button.find '.count'
      countElement.html parseInt(countElement.html(), 10) + 1

    @otherYes.toggleClass 'active', @classification.other is true
    @otherNo.toggleClass 'active', @classification.other is false

    @speciesFinishedButton.attr 'disabled', not @classification.other?

    @renderSummary()

  renderSummary: =>
    groundCovers = []
    for {ground_cover_id} in @classification.groundCovers().all()
      groundCovers.push GroundCover.find(ground_cover_id).description;

    @summaryGroundCoverTable.empty()
    for groundCover in groundCovers
      @summaryGroundCoverTable.append """
        <tr><td>#{groundCover}</td></tr>
      """

    speciesCounts = {}
    for {species} in @classification.markings().all()
      speciesCounts[species] ||= 0
      speciesCounts[species] += 1

    @summarySpeciesTable.empty()
    for species, count of speciesCounts
      @summarySpeciesTable.append """
        <tr>
          <td>#{species}</td>
          <td class="count">#{count}</td>
        </tr>
      """

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
    e ?= target: $('<input />') # Dummy for when we deselect a button

    target = $(e.target)
    species = target.val()

    @picker.selectedSpecies = species
    @picker.selectedMarkerType = target.data 'marker'

    @picker.setDisabled not species

    @indicator.setSpecies species

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

  changeOther: (e) =>
    target = $(e.target)
    value = target.val() is 'yes'
    @classification.updateAttribute 'other', value

  finishSpecies: =>
    @picker.setDisabled true
    @steps.addClass 'finished'

    @fetching = Subject.fetch()

  toggleMap: (show) =>
    unless typeof show is 'boolean' then show = (do -> arguments[0])
    @el.toggleClass 'show-map', show

  goToTalk: =>
    alert 'TODO: Go to talk'

  nextSubject: =>
    @classification.persist()

    @fetching.then (subject) =>
      Subject.setCurrent subject

exports = Classifier
