define (require, exports, module) ->
  module.exports = '''
    <h3 class="value">
      <span class="latitude">0.00 N</span>,
      <span class="longitude">0.00 W</span>
    </h3>

    <section class="images details">
      <nav>
        <ul>
          <li><a href="#!/review/photo">Photo</a></li>
          <li><a href="#!/review/map">Map</a></li>
        </ul>
      </nav>

      <section data-page="photo" class="active">
        <img src="http://placehold.it/770x610" class="subject" />
      </section>

      <section data-page="map">
        <img src="http://placehold.it/770x610" class="map" />
      </section>
    </section>

    <section class="metadata">
      <section>
        <div class="measurement">Date of image capture</div>
        <div class="value"><span class="capture">25 Feb 2012</span></div>
      </section>
      <section>
        <div class="measurement">Altitude above the sea floor</div>
        <div class="value"><span class="altitude">1.8</span> m</div>
      </section>
      <section>
        <div class="measurement">Depth below the surface</div>
        <div class="value"><span class="depth">91.6</span> m</div>
      </section>
      <section>
        <div class="measurement">Water temperature</div>
        <div class="value"><span class="temperature">6.9</span>° C</div>
      </section>
      <section>
        <div class="measurement">Water salinity</div>
        <div class="value"><span class="salinity">32</span> PSU</div>
      </section>
      <section>
        <div class="measurement">Ship's speed</div>
        <div class="value"><span class="speed">4.8</span> kn</div>
      </section>
      <section>
        <div class="measurement">Ship's heading</div>
        <div class="value"><span class="heading">91.5</span>°</div>
      </section>
    </section>
  '''
