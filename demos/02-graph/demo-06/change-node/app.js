import express from 'express';
import path from 'path';
import logger from 'morgan';
import bodyParser from 'body-parser';
import RateLimit from 'express-rate-limit';

import { authRouter } from './routes/auth';
import { listenRouter } from './routes/listen';

export const app = express();

const limiter = new RateLimit({
  windowMs: 2 * 60 * 1000, // 2 minutes
  max: 2400, // 20 rps, these values should be adjusted for production use depending on your infrastructure and the volume of notifications you expect
});

const env = process.env.NODE_ENV || 'development';
app.locals.ENV = env;
app.locals.ENV_DEVELOPMENT = (env === 'development');

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static(path.join(__dirname, 'public')));

app.use('/', authRouter);
app.use('/listen', listenRouter);
app.use(limiter);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  let err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use((err, req, res) => {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err,
      title: 'error'
    });
  });
} else {
  // production error handler
  // no stack traces leaked to user
  app.use((err, req, res) => {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: { },
      title: 'error'
    });
  });
}
