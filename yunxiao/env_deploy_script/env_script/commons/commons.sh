#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-09-08 15:07:13
 # @LastEditTime: 2020-11-01 22:29:40
 # @LastEditors: robert zhang
# @Description: 通用功能
# @
###

set +e
set -o noglob

#
# Set Colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 76)
white=$(tput setaf 7)
tan=$(tput setaf 202)
blue=$(tput setaf 25)

#
# Headers and Logging
#

underline() {
  printf "${underline}${bold}%s${reset}\n" "$@"
}
h1() {
  printf "\n${underline}${bold}${blue}%s${reset}\n" "$@"
}
h2() {
  printf "\n${underline}${bold}${white}%s${reset}\n" "$@"
}
debug() {
  printf "${white}%s${reset}\n" "$@"
}
info() {
  printf "${white}➜ %s${reset}\n" "$@"
}
success() {
  printf "${green}✔ %s${reset}\n" "$@"
}
error() {
  printf "${red}✖ %s${reset}\n" "$@"
}
warn() {
  printf "${tan}➜ %s${reset}\n" "$@"
}
bold() {
  printf "${bold}%s${reset}\n" "$@"
}
note() {
  printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

set -e

check_docker() {
  if ! docker --version &>/dev/null; then
    error "Need to install docker(17.06.0+) first and run this script again."
    exit 1
  fi

  # docker has been installed and check its version
  if [[ $(docker --version) =~ (([0-9]+)\.([0-9]+)([\.0-9]*)) ]]; then
    docker_version=${BASH_REMATCH[1]}
    docker_version_part1=${BASH_REMATCH[2]}
    docker_version_part2=${BASH_REMATCH[3]}

    note "docker version: $docker_version"
    # the version of docker does not meet the requirement
    if [ "$docker_version_part1" -lt 17 ] || { [ "$docker_version_part1" -eq 17 ] && [ "$docker_version_part2" -lt 6 ];}; then
      error "Need to upgrade docker package to 17.06.0+."
      exit 1
    fi
  else
    error "Failed to parse docker version."
    exit 1
  fi
}

