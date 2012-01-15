{exec, spawn} = require 'child_process'

# Setup
# =====

dependencies =
	coffee: 'brew install coffee-script'
	sass:   'gem install sass'

# resources =
# 	'http://code.jquery.com/jquery-1.7.1.js': 'lib/jquery.js'
# 	'http://spinejs.com/pages/download':'lib/spine'
# 	'http://www.fontsquirrel.com/fontfacekit/TitilliumText' : 'lib/TitilliumText'

sourceDir = 'source'
outputDir = 'assets'

# Helpers
# =======

# Check if the commands that the dev server needs exist
check = (success, failure) ->
	remaining = Object.keys(dependencies).length
	failed = false

	for name, installation of dependencies
		exec "which #{name}", (error, stdout, stderr) ->
			remaining -= 1

			if (error)
				console.log("You need #{name}. Try `#{installation}`.")
				failed = true
			
			if (remaining == 0)
				if failed
					failure?()
				else
					success?()

# Download third-party resources
# install = ->

# Run a command and redirect its output
run = (name, options...) ->
	child = spawn name, options, cwd: __dirname

	child.stdout.setEncoding('utf8')
	child.stdout.on 'data', console.log

	child.stderr.setEncoding('utf8')
	child.stderr.on 'data', console.error

	process.on 'exit', -> child.kill()

	return child

# Run an HTTP server, watch CoffeeScript and SASS files for changes.
server = ->
	run 'python', '-m', 'SimpleHTTPServer', 8765
	run 'coffee', '-c', '-o', outputDir, '--watch', sourceDir
	run 'sass', '--watch', "#{sourceDir}:#{outputDir}"

# Tasks
# =====

task 'check', 'Check dev server dependencies', ->
	check -> console.log('All dev server dependencies appear loaded.')

# task 'install', 'Install third-party client libraries and assets', ->
# 	install()
# 	check()

task 'server', 'Run a server, watching changes in "source" to update "assets"', ->
	check(server)
