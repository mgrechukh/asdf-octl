#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/outscale/octl"
TOOL_NAME="octl"
TOOL_TEST="octl --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if octl is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

detect_os() {
  local os="${OS:-}"
  if [ -z "$os" ]; then
    case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      echo 'Linux'
      ;;
    darwin*)
      echo 'Darwin'
      ;;
    msys* | cygwin* | mingw* | nt | win*)
      fail 'windows based os is not supported yet'
      ;;
    *)
      fail "Unknown operating system."
      ;;
    esac
  else
    echo "$os"
  fi
}

detect_arch() {
  local arch="${ARCH:-}"
  if [ -z "$arch" ]; then
    case $(uname -m) in
    x86_64)
      echo "x86_64"
      ;;
    i386)
      echo "i386"
      ;;
    arm64 | aarch64)
      echo "arm64"
      ;;
    *)
      fail "Unsupported architecture: $(uname -m)"
      ;;
    esac
  else
    echo "$arch"
  fi
}

download_release() {
	local version filename url os arch
	version="$1"
	filename="$2"

	os="$(detect_os)"
	arch="$(detect_arch)"
	url="$GH_REPO/releases/download/v${version}/octl_${os}_${arch}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" "$url" || fail "Could not download $url"
	chmod +x "$filename"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_path/$TOOL_NAME"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
