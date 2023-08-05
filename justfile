set export
set dotenv-load

default:
  just --list

format:
  swiftformat .

bootstrap: install-node-modules

install-node-modules:
  npm i
