define (require, exports, module) ->
  Spine = require 'Spine'

  template = require 'views/ProfileFavorite'

  class ProfileFavorite extends Spine.Controller
    @favorite: null

    template: template

    constructor: ->
      super
      @html @template @favorite
      @favorite.bind 'destroy', @release

  module.exports = ProfileFavorite
