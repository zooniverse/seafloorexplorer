$ = parent.require 'jQuery'

host = 'https://login.zooniverse.org'
host = "//#{location.hostname}:3000" unless +location.port is 80

postBack = (command, response) ->
  data = JSON.stringify {command, response}
  parent.postMessage data, "#{location.protocol}//#{location.host}"

issueCommand = (command, params = {}, options = {}) ->
  request = $.getJSON "#{host}/#{command}?callback=?", params

  request.done (response) ->
    postBack options.postAs || command, response

  request.fail (response) ->
    return if options.ignoreFailure
    postBack command, success: false, message: 'Couldn\'t connect to the server'

$(window).on 'message', ({originalEvent: e}) ->
  data = JSON.parse e.data
  issueCommand command, params for command, params of data

issueCommand 'current_user', {}, postAs: 'login', ignoreFailure: true
