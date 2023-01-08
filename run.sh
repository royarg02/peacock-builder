#!/bin/sh

# Determine which release needs to be built from the invoked script
echo "$0" | grep -q "run.sh" || lite_flag="Y"

# Location of Peacock source code
peacock="$GITHUB_WORKSPACE/Peacock"

# Remove old source code if it exists
[ -d "$peacock" ] && rm -rf "$peacock"

# Update apt repositories
sudo apt update

# Setup dependencies
sudo apt install -y git curl jq

# Fetch Peacock source code
git clone "https://github.com/thepeacockproject/Peacock.git" "$peacock"

# Copy any patches in this directory to Peacock folder
find . -maxdepth 1 -regextype posix-egrep -regex '.*\.(rev)?patch' -exec cp {} "$peacock" \;

# Go to the Peacock directory
cd "$peacock" || exit 1

# Switch to provided commit/tag. Defaults to HEAD
git checkout "$1"

# Apply the copied patches
find . -maxdepth 1 -regextype posix-egrep -regex '.*\.(rev)?patch' -exec git apply -- {} \;

# Setup nodejs 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# Setup yarn
sudo apt remove -y cmdtest
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# Build Peacock server
yarn config set --home enableTelemetry 0
yarn
yarn build
yarn optimize

# Create package
./packaging/ciAssemble.sh "$lite_flag"

