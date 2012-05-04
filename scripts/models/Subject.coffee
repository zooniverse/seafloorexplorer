Spine = require 'Spine'

class Subject extends Spine.Model
  @configure 'Subject', 'image', 'latitude', 'longitude', 'depth'

  @server: 'http://localhost:3000'
  @projectId: '4fa4088d54558f3d6a000001'
  @workflowId: '4fa4088d54558f3d6a000001'

  @next: ->
    noClassifications = @select (subject) ->
      subject.classifications().all().length is 0

    noClassifications[0]

exports = Subject
