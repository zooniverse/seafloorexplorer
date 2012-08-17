define (require, exports, module) ->
  $ = require 'jQuery'

  # NOTE: In JavaScript, the % operator finds remainder.
  modulus = (a, b) -> ((a % b) + b) % b

  class ImageFlipper
    el: null
    className: 'image-flipper'

    images: null
    current: 0

    beforeClass: 'before'
    activeClass: 'active'
    afterClass: 'after'

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @el ?= $("<div class='#{@constructor::className}'></div>")
      @el = $(@el)
      @el.addClass @className

      @images ?= @el.children 'img, figure'

      console.log 'New flipper with', @images

      @el.append """
        <div class="flipper-controls">
          <button name="prev"><span class="icon">&#9668;</span><span class="label">Previous</span></button>
          <button name="next"><span class="label">Next</span><span class="icon">&#9658;</span></button>
        </div>
      """

      @el.on 'click', 'button[name="prev"]', @prev
      @el.on 'click', 'button[name="next"]', @next

      @setActive()

    setActive: (@current = @current) ->
      @current = parseInt @current, 10

      for image, i in @images
        console.log image, @current, i
        image = $(image)
        image.toggleClass @beforeClass, i <  @current
        image.toggleClass @activeClass, i is @current
        image.toggleClass @afterClass,  i >  @current

    prev: =>
      @setActive modulus @current - 1, @images.length

    next: =>
      @setActive modulus @current + 1, @images.length

  module.exports = ImageFlipper
