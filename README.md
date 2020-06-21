## Docker

```bash
docker build -f visual_analytics_cuda.Dockerfile -t visual_analytics_cuda:latest .
docker run --rm -it -p 8888:8888 -p 4000:4000 --user "$(id -u):$(id -g)" -v $(pwd):/opt/project/ visual_analytics_cuda /bin/bash
```

cd data && git clone https://github.com/robinske/password-data.git
