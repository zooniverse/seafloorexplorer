define (require, exports, module) ->
  module.exports = (recent) ->
    subject = recent.subjects[0]

    """
      <li>
        <a href="#{subject.talkHref()}"> <img src="#{subject.location}" class="thumbnail" /></a>

        <div class="description">
          <div class="location">#{subject.coords[0]}, #{subject.coords[1]}</div>
          <div class="visited">Visited on #{recent.createdAt}</div>

          <div class="social">
            <a href="#{subject.facebookHref()}" target="_blank" class="facebook">Like on Facebook</a>
            <a href="#{subject.twitterHref()}" target="_blank" class="twitter">Tweet</a>
          </div>
        </div>
      </li>
    """
