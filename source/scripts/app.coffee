class window.App extends Spine.Controller
	constructor: ->
		super
		@routes
			'/:page': (params) ->
				@el.attr 'data-currentr-page', params.page

class window.Main extends Spine.Controller
	constructor: ->
		super
		@routes
			'/classify/:id': (params) ->
				console.log "Will classify #{params.id}"

$ ->
	window.app = new window.App el: $('#wrapper')

	$('[data-controller]').each ->
		new window[@.getAttribute('data-controller')] el: @

	Spine.Route.setup()
