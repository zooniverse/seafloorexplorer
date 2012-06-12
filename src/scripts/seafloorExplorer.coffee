define (require, exports, module) ->
  config = require 'zooniverse/config'

  App = require 'zooniverse/models/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  Map = require 'zooniverse/controllers/Map'
  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Scoreboard = require 'controllers/Scoreboard'
  Profile = require 'controllers/Profile'

  config.set
    name: 'Seafloor Explorer'
    slug: 'seafloor-explorer'
    description: 'Help explore the ocean floor!'
    talkHost: 'http://talk.seafloorexplorer.org'
    cartoUser: 'brian-c'
    cartoApiKey: 'CARTO_API_KEY'
    cartoTable: 'seafloor_explorer_beta'
    facebookId: ''

    app: new App
      el: '#main'
      languages: ['en']

      projects: [
        new Project
          id: '4fa4088d54558f3d6a000001'

          workflows: [
            new Workflow
              id: '4fa408de54558f3d6a000002'
              controller: new Classifier
                el: '#classifier'

              tutorialSubjects: [
                new Subject
                  location: './sample-images/UNQ.20060928.010920609.jpg'
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

    profile: new Profile
      el: '[data-page="profile"]'

    homeMap: new Map
      el: '[data-page="home"] .map'
      layers: ["http://brian-c.cartodb.com/tiles/seafloor_explorer_beta/{z}/{x}/{y}.png"]

    homeScoreboard: new Scoreboard
      el: '[data-page="home"] .scoreboard'
