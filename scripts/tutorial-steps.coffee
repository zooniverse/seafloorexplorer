{Step} = require 'controllers/Tutorial'
{translate} = require 'util'

exports = [
	new Step
		style: left: 170, top: 200, width: 400, height: 'auto'
		content: translate 'tutorialStep0'
		modal: true

	new Step
		style: left: 550, top: 240, width: 270, height: 'auto'
		content: translate 'tutorialStep1'
		nextOn: click: '.ground-cover.toggles button'

	new Step
		style: left: 550, top: 390, width: 300, height: 'auto'
		content: translate 'tutorialStep2'
		nextOn: click: '.ground-cover .finished'

	new Step
		style: left: 550, top: 180, width: 270, height: 'auto'
		content: translate 'tutorialStep3'
		nextOn: 'click': '.species.toggles button[value="fish"]'

	new Step
		style: left: 450, top: 250, width: 150, height: 'auto'
		content: translate 'tutorialStep4'
		modal: true

	new Step
		style: left: 230, top: 360, width: 250, height: 'auto'
		content: translate 'tutorialStep5'
		nextOn: 'click': '#subject'

	new Step
		style: left: 510, top: 220, width: 220, height: 'auto'
		content: translate 'tutorialStep6'
		nextOn: 'click': '#subject'

	new Step
		style: left: 260, top: 40, width: 230, height: 'auto'
		content: translate 'tutorialStep7'
		nextOn: 'click': '#subject'

	new Step
		style: left: 450, top: 480, width: 180, height: 'auto'
		content: translate 'tutorialStep8'
		nextOn: 'click': '#subject'

	new Step
		style: left: 610, top: 130, width: 200, height: 'auto'
		content: translate 'tutorialStep9'
		nextOn: click: '.species.toggles button[value="seastar"]'

	new Step
		style: left: 100, top: 110, width: 200, height: 'auto'
		content: translate 'tutorialStep10'
		modal: true

	new Step
		style: left: 100, top: 110, width: 200, height: 'auto'
		content: translate 'tutorialStep11'
		nextOn: 'click': '#subject'

	new Step
		style: left: 120, top: 120, width: 200, height: 'auto'
		content: translate 'tutorialStep12'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 140, width: 200, height: 'auto'
		content: translate 'tutorialStep13'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 140, width: 200, height: 'auto'
		content: translate 'tutorialStep14'
		nextOn: 'click': '#subject'

	new Step
		style: left: 110, top: 120, width: 200, height: 'auto'
		content: translate 'tutorialStep15'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 110, width: 230, height: 'auto'
		content: translate 'tutorialStep16'
		modal: true

	new Step
		style: left: 560, top: 370, width: 260, height: 'auto'
		content: translate 'tutorialStep17'
		nextOn: click: '.species .finished'

	new Step
		style: left: 840, top: 270, width: 210, height: 'auto'
		content: translate 'tutorialStep18'
		modal: true
]
