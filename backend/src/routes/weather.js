const express = require('express');
const { getWeather } = require('../services/weatherService');

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const latitude = Number(req.query.latitude);
    const longitude = Number(req.query.longitude);

    if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
      return res.status(400).json({
        message: 'Valid latitude and longitude are required.',
      });
    }

    if (latitude < -90 || latitude > 90) {
      return res.status(400).json({
        message: 'Latitude must be between -90 and 90.',
      });
    }

    if (longitude < -180 || longitude > 180) {
      return res.status(400).json({
        message: 'Longitude must be between -180 and 180.',
      });
    }

    const weather = await getWeather(latitude, longitude);

    return res.json(weather);
  } catch (error) {
    console.error(
      'Weather API error:',
      error.response?.data || error.message
    );

    return res.status(500).json({
      message: 'Unable to fetch weather data.',
    });
  }
});

module.exports = router;