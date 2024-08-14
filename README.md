# Destra Decentralized Storage - Storage Node (Beta)

This project contains the codebase necessary to run a storage node for the Destra Decentralized Storage Network. It uses bootstrap nodes registered on DestraStorageBootstrapPeerRegistry contract for `libp2p` peer-to-peer network capabilities, `ethers` for Ethereum blockchain interactions, and several other libraries to support decentralized data storage architecture.

## Prerequisites

Before you start, you will need:

- Node.js and npm installed. You can download these from [Node.js official website](https://nodejs.org/).
- A public IP address where your node will be accessible.
- A system running Ubuntu.
- Sepolia JSON-RPC Endpoint (Recommended: Infura Sepolia RPC API).
- Wallet with atleast 0.2 Sepolia ETH.

## Setup Instructions

You can start a storage node by either following the one-command setup instructions for your Operating System or manual setup instructions.

### One-Command Setup for Linux/Ubuntu Platforms:

#### Download the Script:

Use the `wget` command below to download the setup script, or retrieve the [destra_storage_ubuntu_setup.sh](https://github.com/DestraNetwork/destra-storage-node/tree/main/scripts/destra_storage_ubuntu_setup.sh) file from the repository.

```
wget https://raw.githubusercontent.com/DestraNetwork/destra-storage-node/main/scripts/destra_storage_ubuntu_setup.sh
```

#### Make the Script Executable:

Change the file permissions to make the script executable by running the following command:

```
chmod +x destra_storage_ubuntu_setup.sh
```

#### Run the Script:

Execute the script with the following command:

```
./destra_storage_ubuntu_setup.sh
```

#### Follow the Prompts:

Follow the on-screen prompts to provide the necessary environment variables. The session will then start in the background using tmux.

#### Access the tmux Session:

You can access the tmux session by using the following commands:

```
tmux ls
tmux attach-session -t storage-node
```

### One-Command Setup for Mac OS:

#### Download the Script:

Download the [destra_storage_mac_setup.sh](https://github.com/DestraNetwork/destra-storage-node/tree/main/scripts/destra_storage_mac_setup.sh) file from the repository.

#### Make the Script Executable:

Change the file permissions to make the script executable by running the following command:

```
chmod +x destra_storage_mac_setup.sh
```

#### Run the Script:

Execute the script with the following command:

```
./destra_storage_mac_setup.sh
```

#### Follow the Prompts:

Follow the on-screen prompts to provide the necessary environment variables. The session will then start in the background using tmux.

#### Access the tmux Session:

You can access the tmux session by using the following commands:

```
tmux ls
tmux attach-session -t storage-node
```

### One-Command Setup for Windows (Experimental):

#### Download the Script:

Download the [destra_storage_windows_setup.ps1](https://github.com/DestraNetwork/destra-storage-node/tree/main/scripts/destra_storage_windows_setup.sh) file from the repository.

#### Run the Script:

Execute the script with the following command:

```
.\destra_storage_windows_setup.ps1
```

#### Follow the Prompts:

Follow the on-screen prompts to provide the necessary environment variables. The session will then start in the background using pm2.

#### Access the tmux Session:

You can access the pm2 session by using the following commands:

```
pm2 list
pm2 logs destra-storage-node
```

### Manual Setup

### Clone the repository

First, clone this repository to your local machine using the following command:

```
git clone https://github.com/DestraNetwork/destra-storage-node
cd destra-storage-node
```

### Install npm dependencies

Run the following command to install the required npm dependencies:

```
npm install
```

### Set up environment variables

You will need to set up environment variables by copying the `.env.example` with following command:

```
cp .env.example .env
```

Now, you need to fill the following env variables:



- RPC_URL: Your Sepolia RPC Endpoint. Example: https://sepolia.infura.io/v3/<Infura_Key>. (You can create an Infura key by logging into https://app.infura.io and copying the key to replace <Infura_Key>).
- PRIVATE_KEY: Your private key. (You can get this from your wallets such as Metamask or any other wallet service provider).
- BOOTSTRAP_CONTRACT_ADDRESS: The address for the Destra Peer Registry. Use this address: 0xf0DB1777c6f5E7Afb6d9a5af095AE008B9B2aA98.
- STORAGE_NODE_CONTRACT_ADDRESS: The address for the Destra Nodes Registry. Use this address: 0x03C66CB1826BDB0395BF31E68Bf7E873e9564fFB.
- PUBLIC_IP: Your public IP address.
- NODE_PORT: The port for your node to listen on. Default for Destra Storage Node is 10806.
- BLOCKSTORE_DIRECTORY: The path for your blockstore directory. Create a new folder named “block_store”
- SUBGRAPH_URL: The URL for the Destra Storage Subgraph. Use this: https://api.studio.thegraph.com/query/69390/destra-storage-bootstrap-nodes/version/latest.


#### Example .env file:

Here is an example of what your configuration might look like:
```
RPC_URL=https://sepolia.infura.io/v3/<Infura_Key>
PRIVATE_KEY=<0xYour_Private_Key>
BOOTSTRAP_CONTRACT_ADDRESS=0xf0DB1777c6f5E7Afb6d9a5af095AE008B9B2aA98
STORAGE_NODE_CONTRACT_ADDRESS=0x03C66CB1826BDB0395BF31E68Bf7E873e9564fFB
PUBLIC_IP=<Your_Public_IP>
NODE_PORT=10806
BLOCKSTORE_DIRECTORY=./block_store/
SUBGRAPH_URL=https://api.studio.thegraph.com/query/69390/destra-storage-bootstrap-nodes/version/latest
```

Replace `<Infura_Key>`, `<Your_Private_Key>`, and `<Your_Public_IP>` with your actual values.

### Configure the firewall

To allow traffic to your node, you'll need to open the specified port in the firewall. On Ubuntu, you can do this with the following commands:

```
sudo ufw allow <Port_for_Node_to_Listen_On>/tcp
```

Replace `<Port_for_Node_to_Listen_On>` with the port number you are using.

#### Example:

```
sudo ufw allow 10806/tcp
```

### Start the Node

Now, you can start your storage node with the following command. We recommend using tmux or screen:

```
npm run destra-storage-node
```

This will initialize your storage node, connects it with the bootstrap nodes and joins the Destra Storage Network


## Contributing

Contributions are welcome! Please feel free to submit pull requests to the project.

## Support

For support, open an issue in the GitHub issue tracker for this repository.

Thank you for participating in the Destra network!
