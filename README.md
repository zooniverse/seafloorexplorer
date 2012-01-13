Dependencies
------------

lib/jquery.js

    http://code.jquery.com/jquery-1.7.1.js

lib/spine/

    http://spinejs.com/pages/download

lib/TitilliumText-fontfacekit/

    http://www.fontsquirrel.com/fontfacekit/TitilliumText
    
Apps
----

coffee

    brew install coffee-script
    
sass

    gem install sass

Build assets from source
-----------------------------

    $ coffee -c -o assets --watch source
    $ sass --watch source:assets
