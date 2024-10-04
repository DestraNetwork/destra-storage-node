#!/bin/bash

# Function to update package list and install dependencies
install_dependencies() {
    echo "Updating package list and installing necessary packages..."
    sudo apt update
    sudo apt install -y build-essential curl git tmux sed
    echo "Dependencies installed successfully."
}

# Function to install or update nvm (Node Version Manager)
install_nvm() {
    if [ -d "$HOME/.nvm" ]; then
        echo "nvm already installed. Updating nvm..."
        cd "$HOME/.nvm" && git fetch origin && git checkout v0.40.0 && cd -
    else
        echo "Installing nvm..."
        /bin/bash -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash)"
    fi
    source ~/.nvm/nvm.sh
    echo "nvm installed and sourced successfully."
}

# Install and use Node.js version 20.16.0
install_node() {
    echo "Installing Node.js version 20.16.0 using nvm..."
    nvm install 20.16.0
    nvm use 20.16.0
    nvm alias default 20.16.0
    echo "Node.js v20.16.0 installed and set as the default version."
}

# Install necessary dependencies
install_dependencies

# Install or update nvm
install_nvm

# Ensure Node.js 20.16.0 is installed and used
install_node

# Check if npm is installed and its version
NPM_VERSION="10.8.1"
INSTALLED_NPM_VERSION=$(npm -v 2>/dev/null)
if [ "$INSTALLED_NPM_VERSION" != "$NPM_VERSION" ]; then
    echo "npm version is different from $NPM_VERSION. Installing npm v$NPM_VERSION..."
    npm install -g npm@$NPM_VERSION
else
    echo "npm is already at the required version."
fi

# Clone the repository
git clone https://github.com/DestraNetwork/destra-storage-node
cd destra-storage-node

# Install npm dependencies
npm install

# Copy .env.example to .env
#cp .env.example .env

# Prompt user for input
#read -p "Enter your Sepolia RPC Endpoint (e.g., https://sepolia.infura.io/v3/<Infura_Key>): " RPC_URL
#read -p "Enter your private key: " PRIVATE_KEY

# Check if the private key starts with "0x" and prepend it if necessary
if [[ "$PRIVATE_KEY" != 0x* ]]; then
    PRIVATE_KEY="0x$PRIVATE_KEY"
fi

#read -p "Enter your public IP address: " PUBLIC_IP
#read -p "Enter the port for your node to listen on (default: 10806): " NODE_PORT
#NODE_PORT=${NODE_PORT:-10806}  # Set default port if none provided

# Default values for fixed contract addresses and URLs
#BOOTSTRAP_CONTRACT_ADDRESS="0xf0DB1777c6f5E7Afb6d9a5af095AE008B9B2aA98"
#STORAGE_NODE_CONTRACT_ADDRESS="0x03C66CB1826BDB0395BF31E68Bf7E873e9564fFB"
#BLOCKSTORE_DIRECTORY="./block_store/"
#SUBGRAPH_URL="https://api.studio.thegraph.com/query/69390/destra-storage-bootstrap-nodes/version/latest"

# Update .env with the provided values using sed
# sed -i "s|RPC_URL=|RPC_URL=$RPC_URL|" .env
# sed -i "s|PRIVATE_KEY=|PRIVATE_KEY=$PRIVATE_KEY|" .env
# sed -i "s|BOOTSTRAP_CONTRACT_ADDRESS=|BOOTSTRAP_CONTRACT_ADDRESS=$BOOTSTRAP_CONTRACT_ADDRESS|" .env
# sed -i "s|STORAGE_NODE_CONTRACT_ADDRESS=|STORAGE_NODE_CONTRACT_ADDRESS=$STORAGE_NODE_CONTRACT_ADDRESS|" .env
# sed -i "s|PUBLIC_IP=|PUBLIC_IP=$PUBLIC_IP|" .env
# sed -i "s|NODE_PORT=10806|NODE_PORT=$NODE_PORT|" .env
# sed -i "s|BLOCKSTORE_DIRECTORY=./block_store/|BLOCKSTORE_DIRECTORY=$BLOCKSTORE_DIRECTORY|" .env
# sed -i "s|SUBGRAPH_URL=|SUBGRAPH_URL=$SUBGRAPH_URL|" .env



# Start a tmux session named storage-node
#tmux new-session -d -s storage-node

# Run the storage node inside the tmux session
#tmux send-keys -t storage-node "npm run destra-storage-node" C-m

#echo "Destra Storage Node setup completed and running in tmux session 'storage-node'."

