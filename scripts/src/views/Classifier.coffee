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
			</div>

			<div class="summary">
				<p>Thanks!</p>
				<div class="map-toggle">
					<div class="thumbnail"><img /></div>
					<div class="map"><img /></div>
				</div>

				<button class="favorite">Add to my favorites</button>

				<p>Would you like to discuss this image in Talk?</p>

				<div class="talk">
					<button value="yes">Yes</button>
					<button value="no">No</button>
				</div>
			</div>
		</div>
	'''
