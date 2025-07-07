#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Detected system is MacOS. Executing dotfiles installation using brew."
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing..."
        echo "Verifying xcode command line tools are installed..."
        xcode-select --install
        echo "Done. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew installation complete. Adding to path..."
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
        echo "Homebrew is now installed and added to your PATH."
        exit 1
    fi
    export INSTALL_CMD="brew install"
    # usage in install.sh scripts: /bin/bash -c "$INSTALL_CMD PACKAGE_NAME"
fi

/bin/bash -c "$INSTALL_CMD ripgrep"
# Recursively find and execute all "install.sh" scripts in this directory
find . -name "install.sh" -type f -not -path "./install.sh" -exec zsh {} \;
