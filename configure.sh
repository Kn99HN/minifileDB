# /bin/bash

mkdir segments 2> /dev/null
segment = $(echo "$SEGMENT_FILE")

if [ -z $segment ]; then
  echo "export SEGMENT_FILES=\"~/minifileDB/segments\"" >> ~/.bashrc
fi

source ~/.bashr

