define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      content: [
        'Welcome to Seafloor Explorer!'
        'This tutorial will step you through the classification process.'
        'NOTE: This won\'t entirely make sense until I find the right image. Pretend the scallop is a sea star.'
      ]
      continueText: 'Begin'
      style: width: 410
      attach: to: '.creature-picker'
      block: '.options'

    new Step
      content: [
        'First, choose one or more ground cover from the list that best describes what you see in the image'
        'This one looks like mostly sand...'
      ]
      attach: x: 'right', to: '[value="sand"]', at: x: 'left'
      nextOn: click: '.ground-cover .toggles button:contains("Sand")'
      arrowClass: 'right-middle'
      style: width: 360
      block: '.ground-cover .toggles button:not(:contains("Sand")), .ground-cover .finished'

    new Step
      content: [
        '...and there\'s gravel as well.'
      ]
      attach: x: 'right', to: '[value="gravel"]', at: x: 'left'
      nextOn: click: '.ground-cover .toggles button:contains("Gravel")'
      style: width: 250
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not(:contains("Gravel")), .ground-cover .finished'

    new Step
      content: [
        'Click "Done" once you\'re finished.'
      ]
      attach: x: 'right', to: '.ground-cover .finished', at: x: 'left'
      nextOn: click: '.ground-cover .finished'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Next, identify the species in the image.'
        'We\'ll do the fish first. Choose "fish" from the list of species.'
      ]
      attach: x: 'right', to: '[value="fish"]', at: x: 'left'
      style: width: 400
      nextOn: click: '.species .toggles button:contains("Fish")'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not(:contains("Fish")), .species .finished'

    new Step
      content: [
        'Mark the fish along its longest and widest dimensions.'
        'Start by clicking and dragging your mouse from the fish\'s head to its tail'
      ]
      attach: y: 'top', to: '.creature-picker', at: y: 'top'
      style: width: 550
      nextOn: 'create-stray-axis': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'Then drag along the width of the fish at the widest point along the fish\'s body.'
        'You don\'t need to include fins, if it has any.'
      ]
      attach: y: 'top', to: '.creature-picker', at: y: 'top'
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'Next we\'ll mark a seastar. Choose it from the species list.'
      ]
      attach: x: 'right', to: '[value="seastar"]', at: x: 'left'
      style: width: 400
      nextOn: click: '.species .toggles button:contains("Seastar")'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not(:contains("Seastar")), .species .finished'

    new Step
      content: [
        'Mark the seastar by clicking in the center and dragging out to the tip of its longest arm'
      ]
      attach: y: 'bottom', to: '.creature-picker', at: x: 0.25, y: 0.25
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'down-center'

    new Step
      content: [
        'If there are species in the image other than the ones in the list, we\'d like to know!'
        'Click "No" here since there are no extra creatures in this image.'
      ]
      attach: x: 'right', to: '.other-creatures h4', at: x: 'left'
      style: width: 310
      nextOn: click: '.other-creatures [value="no"]'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Done Identifying and Marking'
        'Once we\'ve finished marking all species, click "Done"'
      ]
      attach: x: 'right', to: '.species .finished', at: x: 'left'
      style: width: 360
      nextOn: click: '.species .finished'
      arrowClass: 'right-middle'

    new Step
      content: [
        'Great job!'
        'Now you\'re ready to try some classifications on your own.'
      ]
      attach: to: '.creature-picker'
      style: width: 400
      continueText: 'Dive in!'
  ]
