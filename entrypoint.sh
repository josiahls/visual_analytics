#!/bin/bash

#source activate visual_analytics && nbdev_build_docs
#cd docs
#bundle exec jekyll serve --host=0.0.0.0 --port=4001 &

#cd ../
#/bin/bash -c "source activate visual_analytics" # && python setup.py develop
/bin/bash -c "source activate visual_analytics && jupyter lab --ip=0.0.0.0 --port=8889 --no-browser --notebook-dir=/opt/project/ --allow-root"

exec "$@"