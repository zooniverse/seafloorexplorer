{Step} = require 'controllers/Tutorial'
{translate} = require 'util'

exports = [
	new Step
		style: left: 170, top: 200, width: 400, height: 'auto'
		content: translate 'tutorialWelcome'
		modal: true

	new Step
		style: left: 400, top: 160, width: 340, height: 'auto'
		className: 'top right'
		content: translate 'tutorialGroundCover'
		nextOn: click: '.ground-cover.toggles button'

	new Step
		style: left: 400, top: 340, width: 340, height: 'auto'
		className: 'bottom right'
		content: translate 'tutorialGroundCoverFinished'
		nextOn: click: '.ground-cover .finished'

	new Step
		style: left: 320, top: 200, width: 420, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFish'
		nextOn: 'click': '.species.toggles button[value="fish"]'

	new Step
		style: left: 260, top: 280, width: 330, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialFishHead'
		nextOn: 'click': '#subject'

	new Step
		style: left: 370, top: 250, width: 310, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFishTail'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 20, width: 220, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFishLeft'
		nextOn: 'click': '#subject'

	new Step
		style: left: 220, top: 510, width: 270, height: 'auto'
		className: 'bottom right'
		content: translate 'tutorialFishRight'
		nextOn: 'click': '#subject'

	new Step
		style: left: 420, top: 160, width: 320, height: 'auto'
		className: 'top right'
		content: translate 'tutorialSeastar'
		nextOn: click: '.species.toggles button[value="seastar"]'

	new Step
		style: left: 190, top: 130, width: 390, height: 'auto'
		content: translate 'tutorialSeastarExplanation'
		modal: true

	new Step
		style: left: 190, top: 130, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastar1'
		nextOn: 'click': '#subject'

	new Step
		style: left: 240, top: 150, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastar2'
		nextOn: 'click': '#subject'

	new Step
		style: left: 240, top: 220, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastar3'
		nextOn: 'click': '#subject'

	new Step
		style: left: 160, top: 230, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastar4'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 180, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastar5'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 180, width: 360, height: 'auto'
		content: translate 'tutorialSeastarExtraLegs'
		modal: true

	new Step
		style: left: 260, top: 400, width: 480, height: 'auto'
		className: 'top right'
		content: translate 'tutorialSpeciesFinished'
		nextOn: click: '.species .finished'

	new Step
		style: left: 260, top: 400, width: 390, height: 'auto'
		content: translate 'tutorialComplete'
		modal: true
]
