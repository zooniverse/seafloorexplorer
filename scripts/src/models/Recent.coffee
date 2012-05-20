define (require, exports, module) ->
  Spine = require 'Spine'

  class Recent extends Spine.Model
    @configure 'Recent'

  module.exports = Recent
