var gulp = require('gulp');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var coffee = require('gulp-coffee');

var distName = 'dllgame.min.js';
var distFolder = './dist/';
var files = [
  './src/utils.coffee',
  './src/game.coffee',
  './src/plot.coffee',
  './src/stage.coffee',
  './src/speaker.coffee',
  './src/avatar.coffee',
  './src/selector.coffee'
];

gulp.task('default', ['dist'], function() {
  console.log("Start to watch *.coffee...");
});

gulp.task('dist', function() {
  gulp.src(files)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat(distName))
    .pipe(uglify())
    .pipe(gulp.dest(distFolder));
});

gulp.watch(files, ['dist']);
