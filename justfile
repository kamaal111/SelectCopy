set export
set dotenv-load

default:
  just --list

format:
  swiftformat .

bootstrap: install-node-modules install-brew-packages

[private]
install-node-modules:
  npm i

[private]
install-brew-packages:
  #!/bin/zsh

  export HOMEBREW_NO_AUTO_UPDATE=1

  brew update
  brew tap homebrew/bundle
  brew bundle
