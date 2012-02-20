Seafloor Zoo
============

Install
-------

    bundle install
    grabass assets.json

Run
---

    jekyll --auto --server

Minify JavaScript
-----------------

	npm install -g requirejs
    cd _site/scripts
    r.js -o baseUrl=. name=main out=main.build.js

Notes
-----

CoffeeScript files in **scripts** are compiled to CommonJS-style AMD modules, so you can use `require` and `exports`.
