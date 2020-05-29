#!/bin/sh
set -e

if [[ ! -d ./input ]]; then
  echo "No input directory mounted"
  exit 1
fi

INPUT=`find ./input -type f -name "*json" | head -1` 

echo "Using Avro schema from $INPUT"

java -jar ./arg.jar -f "$INPUT"
