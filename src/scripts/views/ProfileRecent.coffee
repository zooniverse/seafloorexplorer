define (require, exports, module) ->
  {formatDate} = require 'zooniverse/util'

  module.exports = (recent) ->
    subject = recent.subjects[0]

    """
      <li>
        <a href="#{subject.talkHref()}"> <img src="#{subject.location.thumbnail}" class="thumbnail" /></a>

        <div class="description">
          <div class="location">
            <div class="lat">Lat: #{subject.coords[0]}</div>
            <div class="long">Lng: #{subject.coords[1]}</div>
            <div class="visited">Visited on #{formatDate recent.createdAt}</div>
          </div>
        </div>
      </li>
    """
