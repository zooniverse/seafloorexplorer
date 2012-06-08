define (require, exports, module) ->
  {formatDate} = require 'zooniverse/util'

  module.exports = (recent) ->
    subject = recent.subjects[0]

    """
      <li>
        <a href="#{subject.talkHref()}"> <img src="#{subject.location}" class="thumbnail" /></a>

        <div class="description">
          <div class="location">
            <div>Lat: #{subject.coords[0]}</div>
            <div>Lng: #{subject.coords[1]}</div>
            <div>Visited on #{formatDate recent.createdAt}</div>
          </div>
        </div>
      </li>
    """
