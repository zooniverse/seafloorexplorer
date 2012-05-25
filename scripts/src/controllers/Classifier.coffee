define (require, exports, module) ->
  $ = require 'jQuery'

  Workflow = require 'zooniverse/controllers/Workflow'

  CreaturePicker = require 'controllers/CreaturePicker'
  MarkerIndicator = require 'controllers/MarkerIndicator'
  Pager = require 'zooniverse/controllers/Pager'

  Subject = require 'models/Subject'
  Classification = require 'models/Classification'
  Favorite = require 'zooniverse/models/Favorite'

  Tutorial = require 'controllers/Tutorial'
  tutorialSteps = require 'tutorialSteps'

  TEMPLATE = require 'views/Classifier'

  class Classifier extends Workflow
    @template: TEMPLATE

    picker: null
    indicator: null

    tutorial: null

    events:
      'click .ground-cover .toggles button': 'toggleGroundCover'
      'click .ground-cover .finished': 'finishGroundCover'
      'click .species .toggles button': 'changeSpecies'
      'click .species .other-creatures button': 'changeOther'
      'click .species .finished': 'finishSpecies'
      'click .summary .favorite': 'addFavorite'
      'click .map-toggle img': 'toggleMap'
      'click .talk [value="yes"]': 'goToTalk'
      'click .talk [value="no"]': 'nextSubject'

    elements:
      '.steps': 'steps'
      '.ground-cover .toggles': 'groundCoverList'
      '.ground-cover .finished': 'groundCoverFinishedButton'
      '.species .toggles button': 'speciesButtons'
      '.species .other-creatures [value="yes"]': 'otherYes'
      '.species .other-creatures [value="no"]': 'otherNo'
      '.species .finished': 'speciesFinishedButton'
      '.summary .map-toggle .thumbnail img': 'imageThumbnail'
      '.summary .map-toggle .map img': 'mapThumbnail'

    constructor: ->
      super

      @indicator = new MarkerIndicator
        el: @el.find '.indicator'

      @picker = new CreaturePicker
        el: @el.find '.image'
        indicator: @indicator

      @picker.bind 'change-selection', @renderSpeciesPage

      new Pager el: pager for pager in @el.find('[data-page]').parent()

      for id, description of Subject.groundCovers
        # TODO: Include this in the view.
        @groundCoverList.append """
          <li><button value="#{id}">#{description}</button></li>
        """

    subjectChanged: =>
      super

      @picker.changeClassification @classification

      @picker.image.attr 'src', Subject.current.image
      @picker.map.attr 'src', "http://maps.googleapis.com/maps/api/staticmap?center=#{Subject.current.latitude},#{Subject.current.longitude}&zoom=10&size=745x570&maptype=satellite&sensor=false"

      @imageThumbnail.attr 'src', Subject.current.image
      @mapThumbnail.attr 'src', "http://maps.googleapis.com/maps/api/staticmap?center=#{Subject.current.latitude},#{Subject.current.longitude}&zoom=10&size=745x570&maptype=satellite&sensor=false"

      @changeSpecies null

      @steps.removeClass 'finished'

      location.hash = '#!/classify/ground-cover' if ~location.hash.indexOf '/classify'
      @el.toggleClass 'show-map', false

    render: =>
      @renderGroundCoverPage()
      @renderSpeciesPage()

    renderGroundCoverPage: =>
      for button in @groundCoverList.find 'button'
        button = $(button)
        groundCoverActive = button.attr('value') in @classification.groundCovers
        button.toggleClass 'active', groundCoverActive

      groundCoverPicked = @classification.groundCovers.length isnt 0
      @groundCoverFinishedButton.attr 'disabled', not groundCoverPicked

    renderSpeciesPage: =>
      selectedMarker = (m for m in @picker.markers when m.selected)[0]
      if selectedMarker
        @speciesButtons.filter("[value='#{selectedMarker.marking.species}']").trigger 'click'

      @speciesButtons.find('.count').html '0'
      for marking in @classification.markings().all()
        button = @speciesButtons.filter "[value='#{marking.species}']"
        countElement = button.find '.count'
        countElement.html parseInt(countElement.html(), 10) + 1

      @otherYes.toggleClass 'active', @classification.otherSpecies is true
      @otherNo.toggleClass 'active', @classification.otherSpecies is false

      @speciesFinishedButton.attr 'disabled', not @classification.otherSpecies?

    toggleGroundCover: (e) =>
      value = $(e.target).val()

      if value in @classification.groundCovers
        @classification.groundCovers.splice i, 1 for gc, i in @classification.groundCovers when gc is value
      else
        @classification.groundCovers.push value

      @classification.trigger 'change'

    finishGroundCover: =>
      location.hash = '#!/classify/species'

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
      @classification.updateAttribute 'otherSpecies', value

    finishSpecies: =>
      @picker.setDisabled true
      @steps.addClass 'finished'
      @saveClassification()

    addFavorite: =>
      favorite = Favorite.create subjects: [Subject.current]
      favorite.persist()

    toggleMap: (show) =>
      unless typeof show is 'boolean' then show = (do -> arguments[0])
      @el.toggleClass 'show-map', show

  module.exports = Classifier
