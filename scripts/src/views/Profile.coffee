define (require, exports, module) ->
  '''
    <section class="login-form content"></section>

    <section class="summary">
      <h3 class="content">Ahoy, <span class="username">username</span>!</h3>
      <div class="map"></div>
      <div class="scoreboard"></div>
    </section>

    <section class="favorites">
      <h4 class="content">Favorites</h4>
      <p class="none content">You haven't marked any favorites.</p>
      <ul>
        <li>
          <img src="http://placehold.it/190x130.png" class="thumbnail" />

          <div class="description">
            <div class="location">Location</div>
            <div class="visited">Visited on <span class="date">00/00/00</span></div>

            <div class="social">
              <iframe src="//platform.twitter.com/widgets/tweet_button.html?url=http://www.example.com/" allowtransparency="true" frameborder="0" scrolling="no" style="width: 100px; height: 20px;"></iframe>
              <iframe src="//www.facebook.com/plugins/like.php?href=http://www.example.com/&amp;send=false&amp;layout=button_count&amp;width=450&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:21px;" allowTransparency="true"></iframe>
            </div>
          </div>
        </li>
      </ul>
    </section>
  '''
