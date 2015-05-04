ROOT = "./coffee"
BUILD_PATH    = "./app/assets/javascripts/build"

gulp = require "gulp"

build = (isServerSide) ->
  source     = require "vinyl-source-stream"
  browserify = require "browserify"

  if isServerSide
    entry = "#{ROOT}/server-side-main.cjsx"
    outputName = "server-side-bundle.js"
  else
    entry = "#{ROOT}/main.cjsx"
    outputName = "bundle.js"

  bundler = browserify entry, paths: ['./node_modules', ROOT]
            .transform "coffee-reactify"
            .transform "bulkify"

  if isServerSide
    bundler = bundler.ignore "native-promise-only"

  bundler.bundle()
         .pipe source(outputName)
         .pipe gulp.dest(BUILD_PATH)

gulp.task "cjsx", -> build false

gulp.task "cjsxForServer", -> build true

gulp.task "build", ["cjsx", "cjsxForServer"]
