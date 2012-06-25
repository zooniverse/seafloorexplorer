define (require, exports, module) ->
  config = require 'zooniverse/config'

  App = require 'zooniverse/models/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'
  Map = require 'zooniverse/controllers/Map'
  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Map::tilesId = 65990
  Scoreboard = require 'controllers/Scoreboard'
  Profile = require 'controllers/Profile'

  config.set
    name: 'Seafloor Explorer'
    slug: 'seafloor-explorer'
    description: 'Help explore the ocean floor!'

    domain: 'seafloorExplorer.org'
    talkHost: 'http://talk.seafloorexplorer.org'

    googleAnalytics: 'UA-1224199-30'

    cartoUser: 'brian-c'
    cartoApiKey: 'CARTO_API_KEY'
    cartoTable: 'seafloor_explorer_beta'

  config.set
    app: new App
      el: '#main'
      languages: ['en']

      projects: [
        new Project
          id: '4fdf8fb3c32dab6c95000001'
          devID: '4fa4088d54558f3d6a000001'

          workflows: [
            new Workflow
              id: '4fdf8fb3c32dab6c95000002'
              devID: '4fa408de54558f3d6a000002'
              controller: new Classifier
                el: '#classifier'
                tutorialSteps: tutorialSteps

              tutorialSubjects: [
                new Subject
                  location:
                    standard: 'images/tutorial-subject.jpg'
                    thumbnail: 'images/tutorial-subject.jpg'
                  coords: [0, 0]
                  metadata: {
                    depth: 0
                    altitude: 0
                    heading: 0
                    salinity: 0
                    temperature: 0
                    speed: 0
                    mm_pix: 1
                  }
              ]
          ]
      ]

  config.set
    profile: new Profile
      el: '[data-page="profile"]'

    homeMap: new Map
      el: '[data-page="home"] .map'
      latitude: 40
      longitude: -75
      zoom: 5
      layers: ["http://#{config.cartoUser}.cartodb.com/tiles/#{config.cartoTable}/{z}/{x}/{y}.png"]

    homeScoreboard: new Scoreboard
      el: '[data-page="home"] .scoreboard'

  $ = require 'jQuery'
  $(document).on 'click', "a[href^='#{config.talkHost}']", (e) ->
    e.preventDefault()
    alert '''
      BETA NOTE
      Talk for Seafloor Explorer is coming soon!
    '''
