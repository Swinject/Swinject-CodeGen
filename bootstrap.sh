#!/bin/sh

# exit script, if error
set -e

# defne colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
NOCOLOR=`tput sgr0`

BOOTSTRAP_SOURCE="https://raw.githubusercontent.com/num42/n42-ios-bootstrap-shell/master/bootstrap.sh"

echo "${GREEN}Running N42 Bootstrap v1.13 (2017-02-12)${NOCOLOR}"
echo "${GREEN}If the script fails, there might be a newer Version on $BOOTSTRAP_SOURCE ${NOCOLOR}"
echo "${GREEN}You can directly download it with 'curl -L $BOOTSTRAP_SOURCE -o bootstrap.sh' ${NOCOLOR}"
echo "${GREEN}You can update the script by running "sh bootstrap.sh -u"' ${NOCOLOR}"


if [[ $1 == "-u" ]] ; then
    echo 'Updating bootstrap.sh'
    curl -L $BOOTSTRAP_SOURCE?$(date +%s) -o $0
    exit 1
fi


installDependencyWithBrew(){
  # install dependency, if is not installed
  brew list $1 || brew install $1 || echo "${RED} FAILED TO INSTALL $1 ${NOCOLOR}";

  # upgrade dependency, if it is outdated
  brew outdated $1 || brew upgrade $1 || echo "${RED} FAILED TO UPGRADE $1 ${NOCOLOR}";
}

# updaet brew to keep dependencies up to date
brew update || echo "${RED} FAILED TO UPDATE BREW ${NOCOLOR}";

installDependencyWithBrew rbenv
installDependencyWithBrew ruby-build

# install ruby version from .ruby-version, skipping if already installed (-s)
rbenv install -s

# install bundler gem for ruby dependency management
gem install bundler || echo "${RED} FAILED TO INSTALL BUNDLER ${NOCOLOR}";
bundle install || echo "${RED} FAILED TO INSTALL BUNDLE ${NOCOLOR}";

if [ -e "podfile" ]; then
  # install cocoapods dependencies
  bundle exec pod repo update
  bundle exec pod install || echo "${RED} FAILED TO INSTALL PODS ${NOCOLOR}";
fi

installDependencyWithBrew carthage

# keep submodules up to date, see https://git-scm.com/book/en/v2/Git-Tools-Submodules
git submodule init || echo "${RED} FAILED TO INIT SUBMODULES ${NOCOLOR}";
git submodule update || echo "${RED} FAILED TO UPDATE SUBMODULES ${NOCOLOR}";

if [ -e "fastlane/Fastfile" ]; then
  if bundle exec fastlane lanes | grep "match_all"; then
    # Run fastlane to ensure certs and profiles are installed
    bundle exec fastlane ios match_all || echo "${RED} FAILED TO RUN MATCH ${NOCOLOR}";
  fi
fi
