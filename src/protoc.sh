#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "${BASEDIR}"/protos

PROTOC_GEN_TS_PATH="../../node_modules/.bin/protoc-gen-ts"
GRPC_TOOLS_NODE_PROTOC_PLUGIN="../../node_modules/.bin/grpc_tools_node_protoc_plugin"
GRPC_TOOLS_NODE_PROTOC="../../node_modules/.bin/grpc_tools_node_protoc"

PROTO_OUTPUT_DIR="../../protos"
GENERATED_OUTPUT_DIR="../.."

OutputDirPaths=($PROTO_OUTPUT_DIR)
 
# Create output directories
for path in ${OutputDirPaths[*]}; do
  if [ ! -d $path ]; then
    mkdir $path
  else
    rm -rf $path
    mkdir $path
  fi
done

for filename in ./*; do
  # Ignore non proto files
  if [[ "$filename" != *.proto ]]; then
    continue;
  fi

  # Copy proto file to /protos
  cp $filename $PROTO_OUTPUT_DIR/$filename

  # loop over all the available proto files and compile them into respective dir
  # JavaScript code generating
  ${GRPC_TOOLS_NODE_PROTOC} \
    --js_out=import_style=commonjs,binary:$GENERATED_OUTPUT_DIR \
    --ts_out=$GENERATED_OUTPUT_DIR \
    --grpc_out=$GENERATED_OUTPUT_DIR \
    --plugin=protoc-gen-grpc="${GRPC_TOOLS_NODE_PROTOC_PLUGIN}" \
    "${filename}"

  ${GRPC_TOOLS_NODE_PROTOC} \
    --plugin=protoc-gen-ts="${PROTOC_GEN_TS_PATH}" \
    --ts_out=$GENERATED_OUTPUT_DIR \
    "${filename}"

done