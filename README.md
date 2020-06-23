## Docker

```bash
docker build -f visual_analytics_cuda.Dockerfile -t visual_analytics_cuda:latest .
docker run --rm -it -p 8889:8889 -p 4001:4001 --user "$(id -u):$(id -g)" -v $(pwd):/opt/project/ visual_analytics_cuda /bin/bash
```

cd data && git clone https://github.com/robinske/password-data.git
