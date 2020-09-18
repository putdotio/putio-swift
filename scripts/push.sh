#!/usr/bin/env bash

source ~/.rvm/scripts/rvm
rvm use default

pod lib lint
pod trunk push
