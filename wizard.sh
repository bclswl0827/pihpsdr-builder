#!/usr/bin/env bash

# Define basic variables
BASE_PATH=$(cd `dirname $0`; pwd)
BUILD_DEPENDS="binfmt-support coreutils quilt parted qemu-user-static debootstrap zerofree zip dosfstools bsdtar libcap2-bin rsync xz-utils file git curl bc"

check_environment() {
  if [[ ${UID} -ne '0' ]]; then
    echo "Not running with root, exiting..."
    exit 1
  fi
  if [[ ! -f /usr/bin/apt-get ]]; then
    echo "Not Debian or Ubuntu Linux distributions, exiting..."
    exit 1
  fi
}

initialise_environment() {
  modprobe binfmt_misc
  apt-get update
  apt-get install -y ${BUILD_DEPENDS}
}

execute_build() {
  cd ${BASE_PATH}/builder
  bash -c "./build.sh -c ../config"
}

main() {
  check_environment
  initialise_environment
  execute_build
}
main "$@"; exit
