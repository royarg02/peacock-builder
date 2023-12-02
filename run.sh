#!/bin/sh -x

# Location of Peacock source code
PEACOCK="$GITHUB_WORKSPACE/Peacock"

# The last commit of Peacock requiring the Legacy Escalations plugin
LEGACY_ESC="7f74ac7380f269d8c7e87bff6110d3bb9c949462"

# Determine which release needs to be built from the invoked script
echo "$0" | grep -q "run.sh" && lite_flag="N" || lite_flag="Y"

# Update apt repositories
sudo apt update

# Setup dependencies
sudo apt install -y git curl jq ca-certificates gnupg

# Fetch Peacock source code
git clone "https://github.com/thepeacockproject/Peacock.git" "$PEACOCK"

# Copy any patches from the patches directory to Peacock folder
find patches -regextype posix-egrep -regex '.*\.(rev)?patch' -exec cp {} "$PEACOCK" \;

# Go to the Peacock directory
cd "$PEACOCK" || exit 1

# Switch to provided commit/tag. Defaults to HEAD
git checkout "$1"

# Check if Legacy escalations plugin need to be bundled
git merge-base --is-ancestor HEAD "$LEGACY_ESC" && legacy_esc_flag="Y" || legacy_esc_flag="N"

# Reverse apply the ".revpatch" files before checking if they are an ancestor of
# the HEAD
find . -maxdepth 1 -regextype posix-egrep -regex '.*\.revpatch' | while read -r file; do
  if git merge-base --is-ancestor "$(head -n1 "$file" | cut -d ' ' -f 2)" HEAD; then
    git apply -R "$file"
  fi
done

# Apply the ".patch" files
find . -maxdepth 1 -regextype posix-egrep -regex '.*\.patch' -exec git apply -- {} \;

# Setup nodejs
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=$(sed 's/v//; s/\..*//' < .nvmrc)
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update && sudo apt install -y nodejs

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
./packaging/ciAssemble.sh "$lite_flag" "$legacy_esc_flag"

