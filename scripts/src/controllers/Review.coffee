define (require, exports, module) ->
  Spine = require 'Spine'

  Route = require 'zooniverse/controllers/Route'
  Pager = require 'zooniverse/controllers/Pager'

  TEMPLATE = require 'views/Review'

  class Review extends Spine.Controller
    template: TEMPLATE

    events: {}

    constructor: ->
      super
      @el.html @template
      new Pager el: @el.find '.images'

      # Not ideal...
      new Route '/review/@:subject', (subject) =>
        @loadSubject subject
        location.hash = '#!/review/photo'

    loadSubject: (subject) =>
      console.log "Load subject #{subject} for review"

    exit: (e) =>
      e.preventDefault()
      history.back()

  module.exports = Review
