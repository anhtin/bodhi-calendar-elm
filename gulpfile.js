const gulp = require('gulp');
const elm = require('gulp-elm');
const uglify = require('gulp-uglify');
const exec = require('child_process').exec;

gulp.task('elm', function () {
  return gulp.src('src/Main.elm')
    .pipe(elm.bundle('bundle.js'))
    .pipe(uglify())
    .pipe(gulp.dest('dist/js/'))
});

gulp.task('generate css', function (cb) {
  exec('elm-css src/Stylesheets.elm --output src/',
    function (err, stdout, stderr) {
      if (stdout) console.log(stdout);
      if (stderr) console.log(stderr);
      cb(err);
    }
  );
});

gulp.task('css', ['generate css'], function () {
    return gulp.src('src/main.css')
      .pipe(gulp.dest('dist/css/'))
});

gulp.task('default', ['elm', 'css']);
