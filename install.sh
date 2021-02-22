#!/bin/zsh

source ./sources/colors

# NodeJS
install_nodejs() {
    LATEST_NODEJS_PACKAGE=`curl -s https://nodejs.org/dist/latest/  | grep 'href="node-v' | grep 'pkg' | sort | head -n1  | cut -d'"' -f2` &&
    NODEJS_INSTALLER_PATH="$HOME/Downloads/node-latest.pkg" &&
    curl -s "https://nodejs.org/dist/latest/${LATEST_NODEJS_PACKAGE}" --output ${NODEJS_INSTALLER_PATH} &&
    sudo installer -pkg ${NODEJS_INSTALLER_PATH} -target / > /dev/null &&
    node -v
}

# Starship
install_starship() {
    STARSHIP_INSTALLER_PATH="$HOME/Downloads/starship_installer.sh" &&
    curl -fsSL https://starship.rs/install.sh --output ${STARSHIP_INSTALLER_PATH} &&
    sh ${STARSHIP_INSTALLER_PATH} --yes > /dev/null
}

# Installer
installer() {
    CURRENT_PROGRAM_TO_INSTALL="$1"
    echo "[${GRAY}${BOLD}--${RESET}] Installing ${BLUE}${CURRENT_PROGRAM_TO_INSTALL}${RESET}."
    RESPONSE=`install_$(echo "$CURRENT_PROGRAM_TO_INSTALL" | tr '[:upper:]' '[:lower:]')`
    if [[ $? -eq 0 ]]; then
        echo "[${GREEN}${BOLD}OK${RESET}] Installed ${BLUE}${CURRENT_PROGRAM_TO_INSTALL}${RESET} ${GREEN}${RESPONSE}${RESET}."
    else
        echo "[${RED}${BOLD}KO${RESET}] Failed to download and install ${RED}${CURRENT_PROGRAM_TO_INSTALL}${RESET}."
    fi
}

copy_file() {
    CURRENT_PROGRAM_TO_INSTALL="$2"
    cp $2 $2.save
    cp $1 $2
    if [[ $? -eq 0 ]]; then
        echo "[${GREEN}${BOLD}OK${RESET}] Installed ${BLUE}${CURRENT_PROGRAM_TO_INSTALL}${RESET}."
    else
        echo "[${RED}${BOLD}KO${RESET}] Failed copy ${RED}$1${RESET} to ${RED}$2${RESET}."
    fi
}

# Asks for password.
sudo ls > /dev/null

# installer NodeJS
# installer Starship

echo ""

mkdir -p ~/.config
mkdir -p ~/.git/hooks
mkdir -p ~/.npm/modules
mkdir -p ~/.npm/packages

copy_file sources/zshrc ~/.zshrc
copy_file sources/colors ~/.colors
copy_file sources/gitconfig ~/.gitconfig
copy_file sources/git_hooks/post-checkout ~/.git/hooks/post-checkout
copy_file sources/git_hooks/pre-commit ~/.git/hooks/pre-commit
copy_file sources/starship.toml ~/.starship.toml
copy_file sources/eslintrc ~/.eslintrc
copy_file sources/com.googlecode.iterm2.plist ~/.config/com.googlecode.iterm2.plist

if [[ ! -d 'packages' ]]; then
    git clone --quiet git@github.com:belotte55/packages.git
fi
cp -r packages/node_overloader ~/.npm/modules
rm -rf packages

# osascript scripts/set_iterm_preferences_path.scpt

echo ""
echo "Installation done."
echo "Please restart iTerm."