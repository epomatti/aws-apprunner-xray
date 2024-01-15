import express from "express";

const app = express();
const port = 8080;

async function main() {
  app.get('/', (req, res) => {
    res.send('OK');
  });

  app.get('/api/customer', (req, res) => {
    res.send('Customer');
  });

  app.get('/actuator/health', (req, res) => {
    res.send('Healthy');
  });

  app.listen(port, () => {
    console.log(`[server]: Server is running at http://localhost:${port}`);
  });
}

main()
  .then(async () => {
  })
  .catch(async (e) => {
    console.error(e)
    process.exit(1)
  })