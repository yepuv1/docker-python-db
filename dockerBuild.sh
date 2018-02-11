#!/bin/bash

usage() {
cat << EOF

Usage: dockerBuild.sh -v [version] 
Builds a Docker Image for python3 with oracle, mssql and mysql clients .

Parameters:
   -v: Release version to build. Required. E.g 12.2.1.2.0

EOF
exit 0
}

#Parameters
VERSION="latest"
SKIPMD5=0
while getopts "hv:" optname; do
  case "$optname" in
    "h")
      usage
      ;;
    "v")
      VERSION="$OPTARG"
      ;;
	 *)
    # Should not occur
      echo "Unknown error while processing options inside buildDockerImage.sh"
      ;;
  esac
done

IMAGE_NAME="python3_ora_mss:$VERSION"
BASE_IMAGE=ubuntu:16.04
INST_CLIENT_MAJ_VER=12
INST_CLIENT_MIN_VER=2
INST_CLIENT=instantclient

BUILD_ARG=""

if [ "${BASE_IMAGE}" != "" ]; then
  BUILD_ARG="$BUILD_ARG --build-arg ARG_BASE_IMAGE=${BASE_IMAGE}"
fi

if [ "${INST_CLIENT_MAJ_VER}" != "" ]; then
  BUILD_ARG="$BUILD_ARG --build-arg ARG_INST_CLIENT_MAJ_VER=${INST_CLIENT_MAJ_VER}"
fi

if [ "${INST_CLIENT_MIN_VER}" != "" ]; then
  BUILD_ARG="$BUILD_ARG --build-arg ARG_INST_CLIENT_MIN_VER=${INST_CLIENT_MIN_VER}"
fi

if [ "${INST_CLIENT}" != "" ]; then
  BUILD_ARG="$BUILD_ARG --build-arg ARG_INST_CLIENT=${INST_CLIENT}"
fi

echo "Building image '$IMAGE_NAME' ..."
echo "Proxy Settings '$PROXY_SETTINGS'"
# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build --force-rm=true  $BUILD_ARG -t $IMAGE_NAME -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
    Docker Image for version: $VERSION is ready to be used.

    --> $IMAGE_NAME

    Build completed in $BUILD_ELAPSED seconds.

EOF
else
  echo "Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi