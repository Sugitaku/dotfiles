#!/bin/sh

brew tap homebrew/dupes
brew tap homebrew/versions
brew tap josegonzalez/homebrew-php

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Version Control
brew install android-sdk
brew install --HEAD boris || true
brew install chromedriver
brew install emacs
brew install gawk
brew install git
brew install gnu-sed
brew install gnu-time
brew install htop-osx
brew install httpd
brew install jpeg
brew install jq
brew install libmcrypt
brew install mysql
brew install node
brew install openssl
brew install --HEAD phpenv || true
brew install --HEAD php-build || true
brew install pstree
brew install readline
brew install rbenv
brew install ruby-build
brew install tmux
brew install tig
brew install tree
brew install wget
brew install zsh

# Remove outdated versions from the cellar
brew cleanup

