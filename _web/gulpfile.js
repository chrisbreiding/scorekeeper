var gulp = require('gulp');
var watch = require('gulp-watch');
var zip = require('gulp-zip');

require('zunder')(gulp);

gulp.task('dev-chrome', ['dev'], function () {
  watch({glob: 'chrome-app/*'}, function(files) {
    return files.pipe(gulp.dest('_dev/'));
  });
  watch({glob: 'chrome-app/assets/*.png'}, function(files) {
    return files.pipe(gulp.dest('_dev/assets/'));
  });
});

gulp.task('build-chrome', ['build'], function () {
  gulp.src('chrome-app/*').pipe(gulp.dest('_prod/'));
  return gulp.src('chrome-app/assets/*.png').pipe(gulp.dest('_prod/assets/'));
});

gulp.task('pkg-chrome', ['build-chrome'], function () {
  gulp.src('_prod/**/*')
    .pipe(zip('scorekeeper.zip'))
    .pipe(gulp.dest('_dist/'));
});
