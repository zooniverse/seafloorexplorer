define (require, exports, module) ->
  module.exports = (favorite) ->
    """
      <li>
        <img src="#{favorite.subjects[0].location}" class="thumbnail" />

        <div class="description">
          <div class="location">#{favorite.subjects[0].coords[0]}, #{favorite.subjects[0].coords[1]}</div>
          <div class="visited">Visited on #{favorite.createdAt}</div>

          <div class="social">
            <a href="#{favorite.facebookHref()}" target="_blank" class="facebook">Like on Facebook</a>
            <a href="#{favorite.twitterHref()}" target="_blank" class="twitter">Tweet</a>
          </div>
        </div>
      </li>
    """
