define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      heading: 'Welcome to Seafloor Explorer!'
      content: [
        'This short tutorial will guide you through the classification process.'
        'Please read each step carefully and follow the instructions.'
      ]
      continueText: 'Begin'
      style: width: 450
      attach: to: '.creature-picker'
      block: '.options'

    new Step
      heading: 'Identify ground cover'
      content: [
        'First, choose one or more ground cover from the list that best describes what you see in the image.'
        'Consult the field guide to learn how to identify the different ground covers.'
        'This one looks like mostly sand...'
      ]
      attach: x: 'right', to: '[value="sand"]', at: x: 'left'
      nextOn: click: '.ground-cover [value="sand"]'
      arrowClass: 'right-middle'
      style: width: 360
      block: '.ground-cover .toggles button:not([value="sand"]), .ground-cover .finished'

    new Step
      content: [
        '...with some gravel...'
      ]
      attach: x: 'right', to: '[value="gravel"]', at: x: 'left'
      nextOn: click: '.ground-cover [value="gravel"]'
      style: width: 280
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not([value="gravel"]), .ground-cover .finished'

    new Step
      content: [
        '...and a bit of shell...'
      ]
      attach: x: 'right', to: '[value="shell"]', at: x: 'left'
      nextOn: click: '.ground-cover [value="shell"]'
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not([value="shell"]), .ground-cover .finished'

    new Step
      content: [
        '...and there\'s a big boulder on the left.'
      ]
      attach: x: 'right', to: '[value="boulder"]', at: x: 'left'
      nextOn: click: '.ground-cover [value="boulder"]'
      arrowClass: 'right-middle'
      block: '.ground-cover .toggles button:not([value="boulder"]), .ground-cover .finished'

    new Step
      content: [
        'Click "Done" once you\'re finished.'
      ]
      attach: x: 'right', to: '.ground-cover .finished', at: x: 'left'
      nextOn: click: '.ground-cover .finished'
      arrowClass: 'right-middle'

    new Step
      heading: 'Identify species'
      content: [
        'Next, identify the species in the image.'
        'Consult the field guide to learn how to identify and mark different species. Make sure you don\'t mark dead creatures!'
        'We\'ll mark all the fish first. Choose "Fish" from the list of species.'
      ]
      attach: x: 'right', to: '[value="fish"]', at: x: 'left'
      style: width: 440
      nextOn: click: '.species [value="fish"]'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="fish"]), .species .finished'

    new Step
      heading: 'Marking'
      content: [
        'Mark the fish along its longest and widest dimensions.'
        'Start by clicking and dragging your mouse from the fish\'s head to its tail...'
      ]
      attach: y: 'top', to: '.creature-picker', at: y: 'top'
      style: width: 490
      nextOn: 'create-half-axes-marker': '#classifier'
      arrowClass: 'down-center'
      block: '.species .finished'

    new Step
      content: [
        '...then drag along the width of the fish at the widest point along the fish\'s body.'
        'You don\'t need to include fins, if it has any.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 'left', y: 0.67
      style: width: 310
      nextOn: 'create-axes-marker': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished'

    new Step
      heading: 'Identifying species'
      content: [
        'We\'ve finished marking all the fish in this image.'
        'Next we\'ll mark the seastars. Choose "seastar" from the species list.'
      ]
      attach: x: 'right', to: '[value="seastar"]', at: x: 'left'
      style: width: 460
      nextOn: click: '.species .toggles button:contains("Seastar")'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not(:contains("Seastar")), .species .finished'

    new Step
      heading: 'Marking'
      content: [
        'Mark the seastar by clicking in the center and dragging out to the tip of its longest arm'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.67, y: 0.15
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished'

    new Step
      heading: 'Other species'
      content: [
        'If there are species in the image other than the ones in the list, we\'d like to know!'
        'There are a few sea sponges in this image, so let\'s answer "Yes" to this question.'
      ]
      attach: x: 'right', to: '.other-creatures [value="yes"]', at: x: 'left'
      style: width: 310
      nextOn: click: '.other-creatures [value="yes"]'
      arrowClass: 'right-middle'
      block: '.species .finished'

    new Step
      heading: 'Done Identifying and Marking'
      content: [
        'Now that we\'ve finished marking all species, click "Done"'
      ]
      attach: x: 'right', to: '.species .finished', at: x: 'left'
      style: width: 390
      nextOn: click: '.species .finished'
      arrowClass: 'right-middle'

    new Step
      heading: 'Great job!'
      content: [
        'You can use Talk to discuss images with other volunteers if you have questions or find something interesting.'
        'This concludes the tutorial. Now you\'re ready to dive in and complete some classifications on your own!'
        'If you\'re ever unsure of what to mark, you can always consult the field guide on the "About" page for descriptions of the ground covers and species. You can then return to the "Classify" page when you\'re ready.'
      ]
      attach: x: 'right', to: '.talk p', at: x: 'left'
      style: width: 400
      arrowClass: 'right-middle'
      nextOn: click: '.talk button'
  ]
