Spine = require 'Spine'

SCOREBOARD_TEMPLATE = require 'lib/text!views/Scoreboard.html'

class Scoreboard extends Spine.Controller
  user: null

  template: SCOREBOARD_TEMPLATE

  elements:
    '.seastar.score .count': 'seastarCount'
    '.fish.score .count': 'fishCount'
    '.scallop.score .count': 'scallopCount'
    '.crustacean.score .count': 'crustaceanCount'
    '.cool.score .count': 'coolCount'

  constructor: ->
    super
    @html @template

    # @user.bind 'change', @render
    # Maybe the global count is a special "global" user or something.

  render: =>
    # @seastarCount.html @user.total.seastars
    # @fishCount.html @user.total.fish
    # @scallopCount.html @user.total.scallops
    # @crustaceanCount.html @user.total.crustaceans
    # @coolCount.html @user.total.cools

exports = Scoreboard
