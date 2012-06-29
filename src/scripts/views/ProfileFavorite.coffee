define (require, exports, module) ->
  {formatDate} = require 'zooniverse/util'

  module.exports = (favorite) ->
    subject = favorite.subjects[0]

    """
      <li>
        <button data-favorite="#{favorite.id}" class="delete">&times;</button>
        <a href="#{subject.talkHref()}">
          <img src="#{subject.location.thumbnail}" class="thumbnail" />
          <span class="info">
            <span class="visited">#{formatDate favorite.createdAt}</span>
          </span>
        </a>
      </li>
    """
