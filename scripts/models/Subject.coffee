Spine = require 'Spine'

class Subject extends Spine.Model
  @configure 'Subject', 'zooniverseId', 'image', 'latitude', 'longitude', 'depth'

  @server: 'http://localhost:3000'
  @projectId: '4fa4088d54558f3d6a000001'
  @workflowId: '4fa408de54558f3d6a000002'

  @fromJSON: (raw) ->
    processed =
      id: raw.id
      zooniverseId: raw.zooniverse_id
      image: raw.location
      latitude: raw.coords[0]
      longitude: raw.coords[1]
      depth: raw.metadata.depth

    super processed

  @fetch: ->
    url = "#{@server}/projects/#{@projectId}/workflows/#{@workflowId}/subjects"
    def = new $.Deferred

    @trigger 'fetching'

    $.getJSON url, (response) =>
      def.resolve @fromJSON response[0]

    def.then (subject) =>
      @trigger 'fetch', subject

    def

  @setCurrent: (newCurrent) ->
    return if newCurrent is @current
    @current = newCurrent
    @trigger 'change-current', newCurrent

  @next: ->
    noClassifications = @select (subject) ->
      subject.classifications().all().length is 0

    noClassifications[0]

exports = Subject
