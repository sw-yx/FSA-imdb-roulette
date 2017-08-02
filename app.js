const express = require('express');
const chalk = require('chalk');

const app = express(); // creates an instance of an express application
const http = require('http').Server(app); // https://socket.io/docs/

const morgan = require('morgan');
const nunjucks = require('nunjucks');
const routes = require('./routes');
const bodyParser = require('body-parser');

const blog = x => {
  console.log(chalk.blue(x));
};

const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('imdb-large.sqlite3.db', sqlite3.OPEN_READONLY);

app.use(bodyParser.urlencoded({ extended: false })); // https://github.com/expressjs/body-parser#examples

app.set('view engine', 'html'); // have res.render work with html files
app.engine('html', nunjucks.render); // when giving html files to res.render, tell it to use nunjucks
nunjucks.configure('views', { noCache: true }); // point nunjucks to the proper directory for templates


const myport = process.env.PORT || 3000;
const server = app.listen(myport, () => console.log('listening on ' + myport));
const io = require('socket.io').listen(server);

app.use(express.static('public')); // https://expressjs.com/en/starter/static-files.html
app.use(
  morgan(
    `${chalk.bold.green(':method')} ${chalk.blue(':url')} ${chalk.yellow(
      ':status'
    )}`
  )
);

// app.use('/special/', (req, res, next) => {
//   blog('special area');
//   return next();
// });
app.use('/', routes(io, db));


// app.use(function(req, res, next) {
//   blog(req.statusCode);
//   return next();
// });
