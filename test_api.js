const https = require('https');

const options = {
  headers: {
    'User-Agent': 'PiWeb/1.0'
  }
};

https.get('https://economia.awesomeapi.com.br/last/USD-BRL', options, (res) => {
  console.log('StatusCode:', res.statusCode);
  
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    console.log('Body:', data);
  });
}).on('error', (e) => {
  console.error('Error:', e);
});
