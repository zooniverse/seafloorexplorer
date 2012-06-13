define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {delay} = require 'zooniverse/util'

  ZooniverseClassifier = require 'zooniverse/controllers/Classifier'

  Classification = require 'zooniverse/models/Classification'
  User = require 'zooniverse/models/User'

  CreaturePicker = require 'controllers/CreaturePicker'
  MarkerIndicator = require 'controllers/MarkerIndicator'
  Pager = require 'zooniverse/controllers/Pager'

  TEMPLATE = require 'views/Classifier'

  class Classifier extends ZooniverseClassifier
    template: TEMPLATE

    picker: null
    indicator: null

    availableGroundCovers:
      sand: 'Sand'
      gravel: 'Gravel'
      shellHash: 'Shell hash'
      cobble: 'Cobble'
      boulder: 'Boulder'
      cantTell: 'Can\'t tell'

    events:
      'click .ground-cover .toggles button': 'toggleGroundCover'
      'click .ground-cover .finished': 'finishGroundCover'
      'click .species .toggles button': 'changeSpecies'
      'click .species .other-creatures button': 'changeOther'
      'click .species .finished': 'finishSpecies'
      'click .summary .favorite': 'addFavorite'
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
      '.summary .favorite': 'favoriteButton'
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

      for id, description of @availableGroundCovers
        # TODO: Include this in the view.
        @groundCoverList.append """
          <li><button value="#{id}">#{description}</button></li>
        """

      User.bind 'sign-in', @updateFavoriteButton
      @updateFavoriteButton()

    reset: =>
      @picker.reset()

      super
      @classification.metadata = groundCovers: []

      location.hash = '#!/classify/ground-cover' if ~location.hash.indexOf '/classify'
      @changeSpecies null

      @steps.removeClass 'finished'

      delay 500, =>
        @imageThumbnail.attr 'src', @workflow.selection[0].location

        @mapThumbnail.attr 'src', """
          http://maps.googleapis.com/maps/api/staticmap
          ?center=#{@workflow.selection[0].coords[0]},#{@workflow.selection[0].coords[1]}
          &zoom=10&size=745x570&maptype=satellite&sensor=false
        """.replace /\n/g, ''

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
      for button in @groundCoverList.find 'button'
        button = $(button)
        groundCoverActive = button.attr('value') in @classification.metadata.groundCovers
        button.toggleClass 'active', groundCoverActive

      groundCoverPicked = @classification.metadata.groundCovers.length isnt 0
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

      @otherYes.toggleClass 'active', @classification.metadata.otherSpecies is true
      @otherNo.toggleClass 'active', @classification.metadata.otherSpecies is false

      @speciesFinishedButton.attr 'disabled', not @classification.metadata.otherSpecies?

    updateFavoriteButton: =>
      if User.current?
        @favoriteButton.css display: ''
      else
        @favoriteButton.css display: 'none'

    toggleGroundCover: (e) =>
      value = $(e.target).val()

      if value in @classification.metadata.groundCovers
        for gc, i in @classification.metadata.groundCovers when gc is value
          @classification.metadata.groundCovers.splice i, 1
      else
        @classification.metadata.groundCovers.push value

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
      @classification.metadata.otherSpecies = value
      @classification.trigger 'change'

    finishSpecies: =>
      @picker.setDisabled true
      @steps.addClass 'finished'
      @saveClassification()

    saveClassification: =>
      super

      # NOTE:
      # This doesn't work in IE.
      # But eventually it wil be handled on the back end anyway.
      unless @workflow.selection[0] is @workflow.tutorialSubjects[0]
        subject = @workflow.selection[0]
        annotations = @classification.annotations

        query = "INSERT INTO #{config.cartoTable} (" +
          'the_geom, user_id, scallops, fish, seastars, crustaceans) ' +
          'VALUES (' +
          "ST_SetSRID(ST_Point(#{subject.coords[0]}, #{subject.coords[1]}), 4326), " +
          "'#{User.current?.id || ''}', " +
          "#{(annotation for annotation in annotations when annotation.species is 'scallop').length}, " +
          "#{(annotation for annotation in annotations when annotation.species is 'fish').length}, " +
          "#{(annotation for annotation in annotations when annotation.species is 'seastar').length}, " +
          "#{(annotation for annotation in annotations when annotation.species is 'crustacean').length}" +
          ')'

        $.post "http://#{config.cartoUser}.cartodb.com/api/v2/sql",
          q: query
          api_key: config.cartoApiKey

    toggleMap: (show) =>
      unless typeof show is 'boolean' then show = (do -> arguments[0])
      @el.toggleClass 'show-map', show

  module.exports = Classifier
