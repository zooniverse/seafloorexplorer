define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {delay, remove, arraysMatch} = require 'zooniverse/util'

  ZooniverseClassifier = require 'zooniverse/controllers/Classifier'

  Classification = require 'zooniverse/models/Classification'
  Annotation = require 'zooniverse/models/Annotation'
  User = require 'zooniverse/models/User'

  CreaturePicker = require 'controllers/CreaturePicker'
  MarkerIndicator = require 'controllers/MarkerIndicator'
  Pager = require 'zooniverse/controllers/Pager'

  TEMPLATE = require 'views/Classifier'

  class Classifier extends ZooniverseClassifier
    template: TEMPLATE

    picker: null
    indicator: null

    groundCoverAnnotation: null

    availableGroundCovers: [
      {sand: 'Sand'}
      {shell: 'Shell'}
      {gravel: 'Gravel'}
      {cobble: 'Cobble'}
      {boulder: 'Boulder'}
      {cantTell: 'Can\'t tell'}
    ]

    events:
      'click .ground-cover .toggles button': 'toggleGroundCover'
      'click .ground-cover .finished': 'finishGroundCover'
      'click .species .toggles button': 'changeSpecies'
      'click .species .other-creatures button': 'changeOther'
      'click .species .finished': 'finishSpecies'
      'click .favorite .create button': 'createFavorite'
      'click .favorite .destroy button': 'destroyFavorite'
      'click .map-toggle img': 'toggleMap'
      'click .talk [value="yes"]': 'goToTalk'
      'click .talk [value="no"]': 'nextSubjects'
      'click .tutorial-again': 'startTutorial'

    elements:
      '.steps': 'steps'
      '.ground-cover .toggles': 'groundCoverList'
      '.ground-cover .finished': 'groundCoverFinishedButton'
      '.species .toggles button': 'speciesButtons'
      '.species .other-creatures [value="yes"]': 'otherYes'
      '.species .other-creatures [value="no"]': 'otherNo'
      '.species .finished': 'speciesFinishedButton'
      '.summary .favorite .create': 'favoriteCreation'
      '.summary .favorite .destroy': 'favoriteDestruction'
      '.summary .map-toggle .thumbnail img': 'imageThumbnail'
      '.summary .map-toggle .map img': 'mapThumbnail'

    constructor: ->
      super

      @indicator = new MarkerIndicator
        el: @el.find '.indicator'
        classifier: @

      @picker = new CreaturePicker
        el: @el.find '.image'
        classifier: @

      @picker.bind 'change-selection', @renderSpeciesPage

      new Pager el: pager for pager in @el.find('[data-page]').parent()

      for map in @availableGroundCovers then for id, description of map
        # TODO: Include this in the view.
        @groundCoverList.append """
          <li><button value="#{id}">#{description}</button></li>
        """

      User.bind 'sign-in', @updateFavoriteButtons

    reset: =>
      @picker.reset()

      super
      @groundCoverAnnotation = new Annotation
        classification: @classification,
        value: groundCovers: []
      @otherSpeciesAnnotation = new Annotation
        classification: @classification
        value: otherSpecies: null

      location.hash = '#!/classify/ground-cover' if ~location.hash.indexOf '/classify'
      @changeSpecies null

      @steps.removeClass 'finished'

      delay 500, =>
        @imageThumbnail.attr 'src', @workflow.selection[0].location.thumbnail

        @mapThumbnail.attr 'src', """
          http://maps.googleapis.com/maps/api/staticmap
          ?center=#{@workflow.selection[0].coords[0]},#{@workflow.selection[0].coords[1]}
          &zoom=10&size=745x570&maptype=satellite&sensor=false
        """.replace /\n/g, ''

        @updateFavoriteButtons()

        @el.toggleClass 'show-map', false

        @el.find('.summary .latitude .value').html @classification.subjects[0].coords[0]
        @el.find('.summary .longitude .value').html @classification.subjects[0].coords[1]
        @el.find('.summary .depth .value').html @classification.subjects[0].metadata.depth
        @el.find('.summary .altitude .value').html @classification.subjects[0].metadata.altitude
        @el.find('.summary .heading .value').html @classification.subjects[0].metadata.heading
        @el.find('.summary .salinity .value').html @classification.subjects[0].metadata.salinity
        @el.find('.summary .temperature .value').html @classification.subjects[0].metadata.temperature
        @el.find('.summary .speed .value').html @classification.subjects[0].metadata.speed

    render: =>
      @renderGroundCoverPage()
      @renderSpeciesPage()

    renderGroundCoverPage: =>
      return unless @groundCoverAnnotation
      for button in @groundCoverList.find 'button'
        button = $(button)
        groundCoverActive = button.attr('value') in @groundCoverAnnotation.value.groundCovers
        button.toggleClass 'active', groundCoverActive

      groundCoverPicked = @groundCoverAnnotation.value.groundCovers.length isnt 0
      @groundCoverFinishedButton.attr 'disabled', not groundCoverPicked

    renderSpeciesPage: =>
      selectedMarker = (m for m in @picker.markers when m.selected)[0]
      if selectedMarker
        @speciesButtons.filter("[value='#{selectedMarker.annotation.value.species}']").trigger 'click'

      @speciesButtons.find('.count').html '0'
      for annotation in @classification.annotations
        button = @speciesButtons.filter "[value='#{annotation.value.species}']"
        countElement = button.find '.count'
        countElement.html parseInt(countElement.html(), 10) + 1

      return unless @otherSpeciesAnnotation
      @otherYes.toggleClass 'active', @otherSpeciesAnnotation.value.otherSpecies is true
      @otherNo.toggleClass 'active', @otherSpeciesAnnotation.value.otherSpecies is false

      @speciesFinishedButton.attr 'disabled', not @otherSpeciesAnnotation.value.otherSpecies?

    updateFavoriteButtons: =>
      signedIn = User.current?
      tutorial = arraysMatch @workflow.selection, @workflow.tutorialSubjects
      @el.toggleClass 'can-favorite', signedIn and not tutorial

    toggleGroundCover: (e) =>
      value = $(e.target).val()

      if value in @groundCoverAnnotation.value.groundCovers
        remove value, from: @groundCoverAnnotation.value.groundCovers
      else
        @groundCoverAnnotation.value.groundCovers.push value

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
      @otherSpeciesAnnotation.value.otherSpecies = value
      @classification.trigger 'change'

    finishSpecies: =>
      @picker.setDisabled true
      @steps.addClass 'finished'
      @saveClassification()

    toggleMap: (show) =>
      unless typeof show is 'boolean' then show = (do -> arguments[0])
      @el.toggleClass 'show-map', show

  module.exports = Classifier
