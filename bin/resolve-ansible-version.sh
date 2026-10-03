#!/usr/bin/env bash

# Prints the version of the `ansible` package (e.g. `14.0.0-r0`) that the base
# image of the Dockerfile's final stage currently offers.
#
# Alpine only keeps the latest revision of each package, so the result can
# change over time even if the Dockerfile does not.
# Passing it to the build as `ANSIBLE_VERSION` makes the image contain exactly
# this version (or fail to build), so that it can be tagged ahead of time.
#
# Usage: bin/resolve-ansible-version.sh

set -euo pipefail

repository_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# The last `FROM` is the final stage, which the image is based on.
# The earlier ones are only used for building.
base_image="$(sed -nE 's|^FROM[[:space:]]+([^[:space:]]+).*$|\1|p' "$repository_path/Dockerfile" | tail -n1)"

if [ -z "$base_image" ]; then
	echo >&2 "Could not determine the base image from the Dockerfile"
	exit 1
fi

package="$(docker run --rm "$base_image" sh -c 'apk update -q > /dev/null && apk search -x ansible')"
version="${package#ansible-}"

if ! [[ "$version" =~ ^[0-9][0-9.]*-r[0-9]+$ ]]; then
	echo >&2 "Unexpected ansible package in $base_image: $package"
	exit 1
fi

echo "$version"
