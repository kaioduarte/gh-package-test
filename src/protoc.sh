#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "${BASEDIR}"/protos

PROTOC_GEN_TS_PATH="../../node_modules/.bin/protoc-gen-ts"
GRPC_TOOLS_NODE_PROTOC_PLUGIN="../../node_modules/.bin/grpc_tools_node_protoc_plugin"
GRPC_TOOLS_NODE_PROTOC="../../node_modules/.bin/grpc_tools_node_protoc"
OUTPUT_DIR=../../lib

if [ ! -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
else
  rm -rf $OUTPUT_DIR
  mkdir $OUTPUT_DIR
fi

for filename in ./*; do
  if [[ "$filename" != *.proto ]]; then
    continue;
  fi

  # loop over all the available proto files and compile them into respective dir
  # JavaScript code generating
  ${GRPC_TOOLS_NODE_PROTOC} \
    --js_out=import_style=commonjs,binary:$OUTPUT_DIR \
    --ts_out=grpc_js:$OUTPUT_DIR \
    --grpc_out=grpc_js:$OUTPUT_DIR \
    --plugin=protoc-gen-grpc="${GRPC_TOOLS_NODE_PROTOC_PLUGIN}" \
    "${filename}"

  ${GRPC_TOOLS_NODE_PROTOC} \
    --plugin=protoc-gen-ts="${PROTOC_GEN_TS_PATH}" \
    --ts_out=grpc_js:$OUTPUT_DIR \
    "${filename}"

done