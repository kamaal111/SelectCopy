set export
set dotenv-load

PROJECT := "SelectCopy.xcodeproj"
SCHEME := "SelectCopy"

default:
  just --list

format:
  swiftformat .

bootstrap: install-node-modules install-brew-packages

build:
  #!/bin/zsh

  CONFIGURATION="Debug"

  xctools build --configuration $CONFIGURATION --scheme "$SCHEME" \
    --destination "platform=macOS" --project $PROJECT

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
