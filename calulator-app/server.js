const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Calculator</h1>
    <form method="GET" action="/calculate">
      <input type="number" name="a" required> +
      <input type="number" name="b" required>
      <button type="submit">Calculate</button>
    </form>
  `);
});

app.get('/calculate', (req, res) => {
  const a = parseFloat(req.query.a);
  const b = parseFloat(req.query.b);
  const result = a + b;
  res.send(`<h1>Result: ${result}</h1>`);
});

app.listen(port, () => {
  console.log(`Calculator app listening at http://localhost:${port}`);
});

