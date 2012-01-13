Dependencies
------------

    brew install coffee-script
    gem install sass

lib/jquery.js
    http://code.jquery.com/jquery-1.7.1.js

lib/spine/
    http://spinejs.com/pages/download

lib/TitilliumText-fontfacekit
    http://www.fontsquirrel.com/fontfacekit/TitilliumText

Build assets here from source
-----------------------------

    $ coffee -c -o assets --watch source
    $ sass source:assets
