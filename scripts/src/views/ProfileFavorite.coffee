define (require, exports, module) ->
  module.exports = (favorite) ->
    console.log favorite

    """
      <li>
        <img src="#{favorite.subjects[0].image}" class="thumbnail" />

        <div class="description">
          <div class="location">#{favorite.subjects[0].latitude}, #{favorite.subjects[0].longitude}</div>
          <div class="visited">Visited on #{favorite.createdAt}</div>

          <div class="social">
            <a href="#{favorite.facebookHref()}" class="facebook">Like on Facebook</a>
            <a href="#{favorite.twitterHref()}" class="twitter">Tweet</a>
          </div>
        </div>
      </li>
    """
