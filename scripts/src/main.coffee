require
  # There is some profoundly dumb stuff going on in this config.
  # I do plan on doing something about it.

  paths:
    base64: 'lib/base64'
    jquery: 'lib/jquery'
    spine: 'lib/spine'
    leaflet: 'lib/leaflet'
    raphael: 'lib/blank'
    zooniverse: 'lib/zooniverse'

  shim:
    base64:
      exports: 'base64'

    spine:
      deps: ['jquery']
      exports: 'Spine'

    leaflet:
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

    raphael:
      exports: 'Raphael'

  deps: ['seafloorExplorer']
