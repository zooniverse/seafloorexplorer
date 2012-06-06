{spawn} = require 'child_process'

run = (command...) ->
  child = spawn command...
  child.stderr.on 'data', (data) -> process.stderr.write data.toString()
  child.stdout.on 'data', (data) -> process.stdout.write data.toString()

task 'bootstrap', 'Download dependencies', ->
  # bundle install
  # grabass assets.json
  # git clone zooniverse/Front-End-Assets -b framework ./scripts/src/lib/zooniverse

task 'dev', 'Development server', ->
  run 'coffee', ['--compile', '--output', './scripts', '--watch', './scripts/src']
  run 'coffee', ['--compile', '--watch', './login-frame']
  run 'sass', ['--watch', 'styles/src:styles', '--no-cache', '--debug-info']
  run 'sass', ['--watch', 'scripts/src/lib/zooniverse/styles:styles/zooniverse', '--no-cache', '--debug-info']
  run 'python', ['-m', 'SimpleHTTPServer', 8000]
