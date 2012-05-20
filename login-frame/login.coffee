$ = parent.require 'jQuery'

host = 'https://login.zooniverse.org'
host = "//#{location.hostname}:3000" unless +location.port is 80

postBack = (command, response) ->
  parent.postMessage {command, response}, "#{location.protocol}//#{location.host}"

issueCommand = (command, params = {}, options = {}) ->
  request = $.getJSON "#{host}/#{command}?callback=?", params

  request.done (response) ->
    postBack options.postAs || command, response

  request.fail (response) ->
    return if options.ignoreFailure
    postBack command, success: false, message: 'Couldn\'t connect to the server'

$(window).on 'message', ({originalEvent: e}) ->
  # console.log 'Auth got message', e
  issueCommand command, params for command, params of e.data

issueCommand 'current_user', {}, postAs: 'login', ignoreFailure: true
