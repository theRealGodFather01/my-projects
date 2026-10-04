const axios = require('axios');

async function getWeather(latitude, longitude) {
  const apiKey = process.env.OPENWEATHER_API_KEY;

  if (!apiKey) {
    throw new Error('OpenWeatherMap API key is missing.');
  }

  const response = await axios.get(
    'https://api.openweathermap.org/data/2.5/weather',
    {
      params: {
        lat: latitude,
        lon: longitude,
        appid: apiKey,
        units: 'metric',
      },
    }
  );

  const data = response.data;

  return {
    city: data.name,
    temperature: Number(data.main.temp),
    condition: data.weather[0].description,
  };
}

module.exports = {
  getWeather,
};