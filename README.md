Seafloor Zoo
============

Install
-------

    bundle install
    grabass assets.json
    hub clone -p zooniverse/Front-End-Assets -b framework scripts/src/lib/zooniverse

Run
---

    cake dev

Minify JavaScript
-----------------

	npm install -g requirejs
    cd _site/scripts
    r.js -o baseUrl=. name=main out=main.build.js
