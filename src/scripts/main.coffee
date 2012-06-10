require
  paths:
    base64: 'lib/base64'
    jquery: 'lib/jquery'
    # jQuery explicitly IDs its module as "jquery", which is a .
    # We'll have it load a blank file and shim it to refer to the jQuery function.
    jQuery: 'lib/blank.jQuery'
    Spine: 'lib/spine'
    Leaflet: 'lib/leaflet'
    # Raphael has a fit if a "require" function is present.
    # Make sure it's loaded in its own script tag before RequireJS.
    # Again we'll use a blank file and a shim to refer to it.
    Raphael: 'lib/blank.Raphael'
    zooniverse: 'lib/zooniverse'

  shim:
    base64:
      exports: 'base64'

    jQuery:
      deps: ['jquery']
      exports: ($) ->
        $.noConflict()

    Spine:
      deps: ['jQuery']
      exports: 'Spine'

    Leaflet:
      deps: ['jQuery']
      exports: ($) ->
        styleTags = '''
          <link rel="stylesheet" href="styles/lib/leaflet/leaflet.css" />
          <!--[if lte IE 8]>
              <link rel="stylesheet" href="styles/lib/leaflet/leaflet.ie.css" />
          <![endif]-->
        '''

        head = $('head')
        head.append styleTags unless ~head.html().indexOf 'leaflet.css'

        L # Leaflet goes by "L". Its noConflict method is broken as of 3.1.

    Raphael:
      exports: ->
        console.error 'Raphael needs its own <script> tag before RequireJS.' unless Raphael?
        Raphael

  deps: ['seafloorExplorer']
