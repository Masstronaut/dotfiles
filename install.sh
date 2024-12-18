#!/bin/bash

# Recursively find and execute all "install.sh" scripts in this directory
find . -name "install.sh" -type f -not -path "./install.sh" -exec zsh {} \;
