const express = require("express");

const port = 3000;

const app = express();


app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Headers', 'accept, authorization, content-type, x-requested-with');
  res.setHeader('Access-Control-Allow-Methods', 'GET,HEAD');
  res.setHeader('Access-Control-Allow-Origin', '*');

  next();
});

app.use(express.static('dist'))

app.listen(port);

console.log(`Listening on port ${port}`);
console.log(`Visit http://localhost:${port} in a browser`);
