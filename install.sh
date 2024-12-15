#!/bin/bash

# Recursively find and execute all "install.sh" scripts in this directory
find . -name "install.sh" -type f -exec zsh {} \;
