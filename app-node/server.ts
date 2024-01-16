import express from "express";
var xrayExpress = require('aws-xray-sdk-express');

async function main() {

  const app = express();
  const port = 8080;

  // https://github.com/aws/aws-xray-sdk-node/tree/master/packages/core#setup
  // https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-nodejs-middleware.html
  // https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-nodejs-configuration.html

  app.use(xrayExpress.openSegment('MyApp'));

  app.get('/', (req, res) => {
    res.send('OK');
  });

  app.get('/api/customer', (req, res) => {
    res.send('Customer');
  });

  app.get('/actuator/health', (req, res) => {
    res.send('Healthy');
  });

  app.use(xrayExpress.closeSegment());

  app.listen(port, () => {
    console.log(`[server]: Server is running at http://localhost:${port}`);
  });
}

main()
  .then(async () => {
  })
  .catch(async (e) => {
    console.error(e);
    process.exit(1);
  })