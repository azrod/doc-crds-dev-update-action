#!/bin/sh

readonly TAG=${GITHUB_REF#refs/tags/*}
readonly VERSION=${TAG##*/}

PACKAGE=${INPUT_IMPORT_PATH:=github.com/${GITHUB_REPOSITORY}}

# submodules version tags are formatted as <submodule>/vX.Y.Z,
# so we extract the submodule name and append it to the main module
# import path
if [[ "$VERSION" != "$TAG" ]]; then
  PACKAGE=${PACKAGE}/${TAG%"/$VERSION"}
fi

# if version > 1, then add the version scope
readonly MAJOR_VERSION="$(printf '%s' "$VERSION" | cut -d '.' -f 1 | sed 's/v//g')"
if [ $((10#${MAJOR_VERSION})) -gt 1 ]; then
  PACKAGE="$PACKAGE/v$MAJOR_VERSION"
fi

curl -sSfL "https://doc.crds.dev/$PACKAGE@$VERSION"