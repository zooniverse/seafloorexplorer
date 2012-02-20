{Controller} = require 'Spine'
$ = require 'jQuery'

class ScrollTrigger extends Controller
	matcher: null

	name: ''
	deps: null

	constructor: ->
		super
		@name = @el.attr 'data-scroll-name'
		@deps = $("[data-scroll-with='#{@name}']")

	activate: =>
		passedMyself = false
		for trigger in @matcher.triggers
			if trigger is @
				passedMyself = true
			else if passedMyself
				trigger.deactivate 'after'
			else
				trigger.deactivate 'before'

		elAndDeps = @el.add @deps
		elAndDeps.removeClass 'before'
		elAndDeps.removeClass 'after'
		elAndDeps.addClass 'active'

	deactivate: (className) =>
		elAndDeps = @el.add @deps
		elAndDeps.removeClass 'before'
		elAndDeps.removeClass 'after'
		elAndDeps.removeClass 'active'
		elAndDeps.addClass className

class ScrollMatcher extends Controller
	triggers: null

	events:
		scroll: 'onScroll'

	constructor: ->
		super
		@triggers = for element in @$('[data-scroll-name]')
			new ScrollTrigger
				el: element
				matcher: @

		@triggers[0].activate()

	onScroll: =>
		changePoint = @el.height() / 2

		activeTrigger = @triggers[0]
		for trigger in @triggers
			activeTrigger = trigger if trigger.el.offset().top <= changePoint

		activeTrigger.activate()

exports = ScrollMatcher
