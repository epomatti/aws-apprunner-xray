import express from "express";
import AWSXRay from 'aws-xray-sdk';

async function main() {

  const app = express();
  const port = 8080;

  AWSXRay.config([AWSXRay.plugins.ECSPlugin, AWSXRay.plugins.ECSPlugin]);
  const xraySegmentDefaultName = "MyApp";
  app.use(AWSXRay.express.openSegment(xraySegmentDefaultName));

  app.get('/', (req, res) => {
    res.send('OK');
  });

  app.get('/api/customer', (req, res) => {
    res.send('Customer');
  });

  app.get('/actuator/health', (req, res) => {
    res.send('Healthy');
  });

  app.use(AWSXRay.express.closeSegment());

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