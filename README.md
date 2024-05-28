[![build](https://github.com/spvkgn/7zip-static/actions/workflows/build.yml/badge.svg)](https://github.com/spvkgn/7zip-static/actions/workflows/build.yml)
# 7-Zip static build
* statically linked `7zz` built on Alpine Linux (x86_64, x86, aarch64, armhf)
* applied patches from Debian:
	* Disable local echo display when in input passwords
	* Use system locale to select codepage for legacy zip archives
