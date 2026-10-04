require('dotenv').config();

const express = require('express');
const cors = require('cors');

const weatherRouter = require('./routes/weather');

const app = express();

const rateLimit =
  require('express-rate-limit');

const weatherLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: {
    message: 'Too many weather requests.',
  },
});

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'TaskFlow API is running.',
  });
});

app.use(
  '/api/weather',
  weatherLimiter,
  weatherRouter
);

app.listen(PORT, () => {
  console.log(`TaskFlow API running on port ${PORT}`);
});