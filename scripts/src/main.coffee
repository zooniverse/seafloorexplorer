require
  # There is some profoundly dumb stuff going on in this config.
  # I do plan on doing something about it.

  paths:
    base64: 'lib/base64'
    jquery: 'lib/jquery'
    Spine: 'lib/spine'
    Leaflet: 'lib/leaflet'
    Raphael: 'lib/blank'
    zooniverse: 'lib/zooniverse'

  shim:
    base64:
      exports: 'base64'

    Spine:
      deps: ['jquery']
      exports: 'Spine'

    Leaflet:
      deps: ['jquery']
      exports: ($) ->
        styleTags = '''
          <link rel="stylesheet" href="styles/lib/leaflet/leaflet.css" />
          <!--[if lte IE 8]>
              <link rel="stylesheet" href="styles/lib/leaflet/leaflet.ie.css" />
          <![endif]-->
        '''

        head = $('head')
        head.append styleTags unless ~head.html().indexOf 'leaflet.css'

        L # Leaflet goes by "L".

    Raphael:
      exports: 'Raphael'

  deps: ['seafloorExplorer']
