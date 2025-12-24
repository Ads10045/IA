const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 4200;

// Serve static files from the public folder
app.use(express.static(path.join(__dirname, 'public')));

// Handle Angular routing by returning index.html for all requests
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

app.listen(port, () => {
  console.log(`Frontend served on http://localhost:${port}`);
});
