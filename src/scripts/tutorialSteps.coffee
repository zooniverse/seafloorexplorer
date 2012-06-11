define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      content: [
        'Welcome to Seafloor Zoo!'
        'This tutorial will step you through the Seafloor Zoo classification process.'
        'NOTE: This won\'t entirely make sense until I find the right image. Pretend the scallop is a sea star.'
      ]
      attach: x: 'center', y: 'middle', to: '.creature-picker', at: x: 'center', y: 'middle'
      style: width: 400
      block: '.options'

    new Step
      content: [
        'First, we\'ll choose the ground covers from the list that best describes what you can see in the image.'
        'This one looks like mostly sand...'
      ]
      attach: x: 'right', to: '[value="sand"]', at: x: 'left'
      nextOn: click: '.ground-cover .toggles button:contains("Sand")'
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not(:contains("Sand")), .ground-cover .finished'

    new Step
      content: [
        '...and there\'s gravel as well.'
      ]
      attach: x: 'right', to: '[value="gravel"]', at: x: 'left'
      nextOn: click: '.ground-cover .toggles button:contains("Gravel")'
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not(:contains("Gravel")), .ground-cover .finished'

    new Step
      content: [
        'Click "Done" once you\'re finished choosing.'
      ]
      attach: x: 'right', to: '.ground-cover .finished', at: x: 'left'
      nextOn: click: '.ground-cover .finished'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Now we need to classify the creatures in the image.'
        'Let\'s do the fish first. Choose "Fish" from the list of species.'
      ]
      attach: x: 'right', to: '[value="fish"]', at: x: 'left'
      nextOn: click: '.species .toggles button:contains("Fish")'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not(:contains("Fish")), .species .finished'

    new Step
      content: [
        'We\'ll mark the fish by drawing a line across its longest and shortest dimensions.'
        'Start by dragging your mouse from the fish\'s head to its tail'
      ]
      attach: y: 'top', to: '.creature-picker', at: y: 'top'
      nextOn: 'create-stray-axis': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'Then drag from the left side of the fish to the right at the widest point along the fish\'s body.'
      ]
      attach: y: 'top', to: '.creature-picker', at: y: 'top'
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'Next we\'ll mark a seastar. Choose it from the species list.'
      ]
      attach: x: 'right', to: '[value="seastar"]', at: x: 'left'
      nextOn: click: '.species .toggles button:contains("Seastar")'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not(:contains("Seastar")), .species .finished'

    new Step
      content: [
        'We can mark a seastar by simply dragging from its center to the tip of its longest leg.'
        'Give it a try!'
      ]
      attach: y: 'bottom', to: '.creature-picker', at: x: 0.25, y: 0.25
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'If there are species in the image other than the ones in the list, we\'d like to know.'
        'Click "No" here since there are no extra creatures in this image.'
      ]
      attach: x: 'right', to: '.other-creatures h4', at: x: 'left'
      nextOn: click: '.other-creatures [value="no"]'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Once we\'ve finished marking all the species in an image, click "Done".'
      ]
      attach: x: 'right', to: '.species .finished', at: x: 'left'
      nextOn: click: '.species .finished'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Great job!'
        'Now you\'re ready to try some classifications on your own.'
      ]
      attach: to: '.creature-picker'
      continueText: 'Ready!'
  ]
