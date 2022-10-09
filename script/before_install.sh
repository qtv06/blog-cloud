#!/bin/bash
RED='\033[0;31m'

echo -e "${RED}======Before Install=========="

if [ -d /home/deploy/blog-cloud ]; then
  rm -rf /home/deploy/blog-cloud
fi

mkdir -vp /home/deploy/blog-cloud

echo -e "${RED}======End of Before Install===="