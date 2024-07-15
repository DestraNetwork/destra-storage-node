import 'dotenv/config'
import { noise } from '@chainsafe/libp2p-noise'
import { yamux } from '@chainsafe/libp2p-yamux'
import { identify } from '@libp2p/identify'
import { bootstrap } from '@libp2p/bootstrap'
import { tcp } from '@libp2p/tcp'
import { FsBlockstore } from 'blockstore-fs'
import { MemoryDatastore } from 'datastore-core'
import { createHelia } from 'helia'
import { createLibp2p } from 'libp2p'
import { kadDHT, removePrivateAddressesMapper } from '@libp2p/kad-dht'
import { ethers } from 'ethers';
import contractABI from './abis/BootstrapPeerRegistry.json'  with { type: "json" };
import net from 'net';


const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contractAddress = process.env.CONTRACT_ADDRESS;
const contract = new ethers.Contract(contractAddress, contractABI.abi, wallet);


async function fetchPeerIdsFromSubgraph() {
    const query = `
    query GetBootstrapNodes {
      peerRegistereds(first: 8) {
        peerId
        locationMultiAddr
      }
    }
  `;

    const response = await fetch(process.env.SUBGRAPH_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ query }),
    });

    const { data } = await response.json();
    return data.peerRegistereds;
}

async function fetchBootstrapNodes(peerIds) {
    const bootstrapNodes = [];

    for (let peer of peerIds) {
        const nodeDetails = await contract.bootstrapNodes(peer.peerId);
        bootstrapNodes.push(nodeDetails.locationMultiAddr + "/p2p/" + peer.peerId);
    }

    return bootstrapNodes;
}

function pingHost(ip, port, timeout = 10000) {
    return new Promise((resolve, reject) => {
        const socket = new net.Socket();
        const address = `${ip}:${port}`;

        socket.setTimeout(timeout);
        socket.on('connect', () => {
            console.log(`Successfully connected to ${address}`);
            socket.destroy();
            resolve(true);
        });

        socket.on('timeout', () => {
            console.log(`Connection to ${address} timed out.`);
            socket.destroy();
            reject(new Error('Connection timed out'));
        });

        socket.on('error', (err) => {
            console.log(`Connection to ${address} failed: ${err.message}`);
            socket.destroy();
            reject(err);
        });

        socket.connect(port, ip);
    });
}


async function createDestraStorageNode() {
    console.log("Creating Destra Storage Node...");

    console.log("Setting up directory for block store...")
    const blockstore = new FsBlockstore(process.env.BLOCKSTORE_DIRECTORY)

    const datastore = new MemoryDatastore()


    console.log("Configuring libp2p...");

    const peerIds = await fetchPeerIdsFromSubgraph();
    const bootstrapNodes = await fetchBootstrapNodes(peerIds);
    console.log("Fetched the bootstrap nodes from DestraStorageBootstrapPeerRegistry contract at", process.env.CONTRACT_ADDRESS, ":", bootstrapNodes)

    const libp2p = await createLibp2p({
        datastore,
        addresses: {
            listen: [
                `/ip4/0.0.0.0/tcp/${process.env.NODE_PORT}`
            ]
        },
        transports: [
            tcp()
        ],
        connectionEncryption: [
            noise()
        ],
        streamMuxers: [
            yamux()
        ],
        peerDiscovery: [
            bootstrap({
                list: bootstrapNodes
            })
        ],
        services: {
            identify: identify(),
            aminoDHT: kadDHT({
                protocol: '/ipfs/kad/1.0.0',
                peerInfoMapper: removePrivateAddressesMapper
            })
        }
    })

    console.log("libp2p configured. Initializing Destra Storage Node...");


    return await createHelia({
        datastore,
        blockstore,
        libp2p
    })
}



async function main() {
    const destraStorageNode = await createDestraStorageNode()
    console.log("Destra Storage Node initialized successfully.");

    const multiAddrLocation = `/ip4/${process.env.PUBLIC_IP}/tcp/${process.env.NODE_PORT}`
    const peerId = destraStorageNode.libp2p.peerId.toString()

    console.log("Destra Storage Node started with MultiAddress and Peer ID:", multiAddrLocation, peerId);




    console.log("------------------------------------------------\n" +
        "All set, your Destra Storage Node is up and running");
}

main();