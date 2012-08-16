define (require, exports, module) ->
	'''
		<div class="image"><!--Creature picker--></div>

		<div class="options">
			<div class="steps">
				<div data-page="ground-cover" class="ground-cover active">
					<h4>Ground covers in this image</h4>

					<ul class="toggles">
						<!--<li><button value="id">description</button></li>-->
					</ul>

					<button disabled="disabled" class="finished">Done identifying ground cover</button>
				</div>

				<div data-page="species" class="species">
					<h4>Species in this image</h4>

					<ul class="toggles">
						<li><button value="scallop" data-marker="axes">Scallop <span class="count">0</button></li>
						<li><button value="fish" data-marker="axes">Fish <span class="count">0</button></li>
						<li><button value="seastar" data-marker="circle">Seastar <span class="count">0</button></li>
						<li><button value="crustacean" data-marker="axes">Crustacean <span class="count">0</button></li>
					</ul>

					<div class="indicator"><!--Marker indicator--></div>

					<div class="other-creatures">
						<h4>Are there any other species<br />present in this image?</h4>
						<button value="yes">Yes</button>
						<button value="no">No</button>
					</div>

					<button disabled="disabled" class="finished">Done identifying species</button>
				</div>

				<div class="help">
					<span>Need help?</span>
					<a href="#!/about/data/ground-cover/sand/from-classify" title="Check out the field guide" class="field-guide">Field guide</a>
					<a href="#start-tutorial" title="Go through the tutorial again" class="tutorial-again">Tutorial</a>
				</div>
			</div>

			<div class="summary">
				<p>Thanks!</p>
				<div class="map-toggle">
					<div class="thumbnail"><img /></div>
					<div class="map"><img /></div>
				</div>

				<div class="information">
					<div class="latitude">
						<span class="label">Latitude</span>
						<span class="value"></span>°</div>
					<div class="longitude">
						<span class="label">Longitude</span>
						<span class="value"></span>°</div>
					<div class="depth">
						<span class="label">Depth</span>
						<span class="value"></span> M</div>
					<div class="altitude">
						<span class="label">Altitude</span>
						<span class="value"></span> M</div>
					<div class="heading">
						<span class="label">Heading</span>
						<span class="value"></span>°</div>
					<div class="salinity">
						<span class="label">Salinity</span>
						<span class="value"></span> PSU</div>
					<div class="temperature">
						<span class="label">Temperature</span>
						<span class="value"></span>° C</div>
					<div class="speed">
						<span class="label">Speed</span>
						<span class="value"></span> kts</div>
				</div>

				<div class="favorite">
					<div class="create"><button>Add to my favorites</button></div>
					<div class="destroy">Favorite added! <button>Undo</button></div>
				</div>

				<div class="talk">
					<p>Would you like to discuss this image in Talk?</p>
					<button value="yes">Yes</button>
					<button value="no">No</button>
				</div>
			</div>
		</div>
	'''
