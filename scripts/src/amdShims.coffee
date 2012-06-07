define 'jQuery', [
  'lib/jquery'
], -> jQuery

define 'Spine', [
  'jQuery'
  'lib/spine/spine'
], -> Spine

define 'base64', [
  'lib/base64'
], -> base64

define 'Raphael', [
  # Include Raphael in a script tag before RequireJS.
], -> Raphael

define 'Leaflet', [
  'jQuery'
  'lib/leaflet'
], ($) ->
  cssDir = './styles/lib/leaflet'
  styleTags = """
    <link rel="stylesheet" href="#{cssDir}/leaflet.css" />
    <!--[if lte IE 8]><link href="#{cssDir}/leaflet.ie.css" rel="stylesheet" /><![endif]-->
  """

  head = $('head')
  head.append styleTags unless !!~head.html().indexOf cssDir

  L
