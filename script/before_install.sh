#!/bin/bash

if [ -d /home/deploy/blog-cloud ]; then
  rm -rf /home/deploy/blog-cloud
fi

mkdir -vp /home/deploy/blog-cloud