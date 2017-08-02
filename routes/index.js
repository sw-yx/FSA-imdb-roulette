const express = require('express');
const router = express.Router();
// could use one line instead: const router = require('express').Router();
// const tweetBank = require('../tweetBank');

const genres = [
'Action',
'Adult',
'Adventure',
'Animation',
'Comedy',
'Crime',
'Documentary',
'Drama',
'Family',
'Fantasy',
'Film-Noir',
'Horror',
'Music',
'Musical',
'Mystery',
'Romance',
'Sci-Fi',
'Short',
'Thriller',
'War',   
'Western',

]

module.exports = function(io, db) {
  // ...
  // route definitions, etc.
  // ...

  const genRec = (g, cb) => {
    const subq = g ? 
      `SELECT movie_id FROM movies_genres WHERE genre = "${g.replace(/%20/g, " ")}"` :
      `SELECT id AS movie_id FROM movies`

    const q = `SELECT *
      FROM (${subq}) AS swyx
      JOIN movies ON swyx.movie_id = movies.id
      JOIN movies_directors ON swyx.movie_id = movies_directors.movie_id
      JOIN directors ON director_id = directors.id
      WHERE rank > 9
    `
    db.all(q,function(err,rows){
      if (err) throw err
      const selection = rows[Math.floor(Math.random() * rows.length)];
      // enrich selection data
      const mid = selection.movie_id
      const q = `SELECT *
        FROM roles
        JOIN actors ON actor_id = actors.id
        WHERE movie_id = ${mid}
      `
      db.all(q,function(err,roles){
        if (err) throw err
        // res.render('index', {selection,roles});
       cb({selection: selection
         ,roles: roles
        ,genres: genres});
      })
    });
  }

  router.get('/', function(req, res) {
    genRec(null, (x => res.render('index', x)))
  });
  router.get('/roulette/:genre', function(req, res) {
    // db.serialize(function() {
    // db.each("SELECT rowid AS id, info FROM user_info", function(err, row) {
    //       console.log(row.id + ": " + row.info);
    //   });
    // });
    // db.close();
    console.log('hi')

    genRec(req.params.genre, (x => res.json(x)))
  });

//   router.get('/users/:name', function(req, res) {
//     var name = req.params.name;
//     var list = tweetBank.find({ name: name });
//     res.render('index', { tweets: list, showForm: true, username: name });
//   });

//   router.get('/tweets/:id', function(req, res) {
//     var id = +req.params.id;
//     var list = tweetBank.find({ id: id });
//     res.render('index', { tweets: list });
//   });

//   router.post('/tweets', function(req, res) {
//     var name = req.body.name;
//     var text = req.body.text;
//     tweetBank.add(name, text);
//     const tweetobj = tweetBank.find({ name, content: text });
//     io.sockets.emit('newTweet', tweetobj[0]);
//     res.redirect('/');
//   });
  // module.exports = router;
  return router;
};
