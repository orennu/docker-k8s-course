const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send(`
    <h1>Hello from this NodeJS app version 0.0.3!</h1>
    <p>Try sending a request to /error and see what happens</p>
  `);
});

app.get("/error", (req, res) => {
  process.exit(1);
});

app.get("/health", (req, res) => {
  res.sendStatus(200);
  // res.send(`
  //   I'm alive!!!
  // `);
});

app.listen(8080);
