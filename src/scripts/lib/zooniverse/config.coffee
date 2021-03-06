define (require, exports, module) ->
  # This object stores generic information about the app
  # that might need to be available globally.
  config = {}

  # `set` is a shortcut for setting a bunch of properties by passing in an object.
  # Order isn't guaranteed. Call it multiple times if order is important.
  config.set = (options) ->
    for own key, value of options
      throw new Error 'Don\'t overwrite "set" in config.' if key is 'set'
      config[key] = value

  # Determine if we're running on a development server.
  config.set
    dev: +location.port > 1023 or !!~location.hostname.indexOf '.dev'
    demo: !!~location.hostname.indexOf 'demo'

  # Default host and API proxy path
  config.set
    apiHost: 'https://api.zooniverse.org'
    proxyPath: '/proxy.html'

  config.set apiHost: "https://dev.zooniverse.org" if config.demo

  # TODO: What if dev Ouroboros isn't on 3000?
  config.set apiHost: "http://#{location.hostname}:3000" if config.dev

  module.exports = config
