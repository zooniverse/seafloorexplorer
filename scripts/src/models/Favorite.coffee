define (require, exports, module) ->
  Spine = require 'Spine'

  class Favorite extends Spine.Model
    @configure 'Favorite'

  module.exports = Favorite
