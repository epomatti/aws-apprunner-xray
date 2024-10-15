
```sh
docker build -t sample-var-app .
docker run --rm -e DEMO_VAR="123" -t sample-var-app
```


https://staxmanade.com/2016/05/how-to-get-environment-variables-passed-through-docker-compose-to-the-containers/