define (require, exports, module) ->
  ZooniverseSubject = require 'zooniverse/models/Subject'

  class Subject extends ZooniverseSubject
    @configure 'Subject', 'zooniverseId', 'image', 'latitude', 'longitude', 'depth'

    @groundCovers:
      sand: 'Sand'
      cobble: 'Cobble'
      boulder: 'Boulder'
      gravel: 'Gravel'
      shellHash: 'Shell hash'
      cantTell: 'Can\'t tell'

    @fromJSON: (raw) ->
      processed =
        id: raw.id
        zooniverseId: raw.zooniverse_id
        image: raw.location
        latitude: raw.coords[0]
        longitude: raw.coords[1]
        depth: raw.metadata.depth

      super processed

    @forTutorial = ->
      @create
        zooniverseId: 'TUTORIAL_SUBJECT'
        image: 'sample-images/UNQ.20060928.010920609.jpg'
        latitude: 0
        longitue: 0

  module.exports = Subject
