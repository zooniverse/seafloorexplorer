define (require, exports, module) ->
  App = require 'zooniverse/models/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  Map = require 'zooniverse/controllers/Map'
  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Scoreboard = require 'controllers/Scoreboard'
  Profile = require 'controllers/Profile'

  seafloorExplorer = new App
    talkHost: 'http://talk.seafloorexplorer.org'
    cartoUser: 'brian-c'
    cartoApiKey: 'CARTO_API_KEY'
    cartoTable: 'seafloor_explorer_beta'
    facebookId: ''

    languages: ['en']
    el: '#main'

    projects: [
      new Project
        id: '4fa4088d54558f3d6a000001'
        name: 'Seafloor Explorer'
        slug: 'seafloor-explorer'
        description: 'Help explore the ocean floor!'

        workflows: [
          new Workflow
            id: '4fa408de54558f3d6a000002'
            controller: new Classifier
              el: '#classifier'
            tutorialSubjects: [
              new Subject
                location: './sample-images/UNQ.20060928.010920609.jpg'
                coords: [0, 0]
                workflow: {}
            ]
        ]
    ]

  seafloorExplorer.save()

  window.profile = new Profile
    el: '[data-page="profile"]'

  new Map
    el: '[data-page="home"] .map'
    layers: ["http://brian-c.cartodb.com/tiles/seafloor_explorer_beta/{z}/{x}/{y}.png"]

  new Scoreboard
    el: '[data-page="home"] .scoreboard'

  window.app = seafloorExplorer
  module.exports = seafloorExplorer
