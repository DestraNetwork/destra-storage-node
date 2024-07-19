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


```
RPC_URL=<Sepolia_RPC_Endpoint> [Example: https://sepolia.infura.io/v3/<Infura_Key>]
PRIVATE_KEY=<Your_Private_Key>
BOOTSTRAP_CONTRACT_ADDRESS=<Destra_Peer_Registry_Address> [Sepolia: 0xf0DB1777c6f5E7Afb6d9a5af095AE008B9B2aA98]
STORAGE_NODE_CONTRACT_ADDRESS=<Destra_Nodes_Registry_Address> [Sepolia: 0x03C66CB1826BDB0395BF31E68Bf7E873e9564fFB]
PUBLIC_IP=<Your_Public_IP>
NODE_PORT=<Port_for_Node_to_Listen_On> [Default for Destra Storage Node is 10806]
BLOCKSTORE_DIRECTORY=<Path_For_Blockstore>
SUBGRAPH_URL=<URL_For_Destra_Storage_Subgraph> [https://api.studio.thegraph.com/query/69390/destra-storage-bootstrap-nodes/version/latest]
```

Replace `<Sepolia_RPC_Endpoint>`, `<Your_Private_Key>`, `<Destra_Peer_Registry_Address>`, `<Your_Public_IP>`, `<Port_for_Node_to_Listen_On>`, `<Path_For_Blockstore>`, and `URL_For_Destra_Storage_Subgraph>` with your actual values.

### Configure the firewall

To allow traffic to your node, you'll need to open the specified port in the firewall. On Ubuntu, you can do this with the following commands:

```
sudo ufw allow <Port_for_Node_to_Listen_On>/tcp
```

Replace `<Port_for_Node_to_Listen_On>` with the port number you are using.


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
