import { Button, Card, DatePicker, Divider, Input, Progress, Slider, Spin, Switch, Image, List } from "antd";
import React, { useState } from "react";
import { utils } from "ethers";
import { SyncOutlined } from "@ant-design/icons";
import { useEffect } from "react";
import axios from "axios";
import { Address, Balance, Events } from "../components";

export default function CanvasUI({
    address,
    mainnetProvider,
    localProvider,
    yourMainnetBalance,
    yourLocalBalance,
    price,
    tx,
    readContracts,
    writeContracts,
}) {

    const [yourCollectibles, setYourCollectibles] = useState();
    const [canvasImage, setCanvasImage] = useState("");
    const [x, setX] = useState(0);
    const [y, setY] = useState(0);
    const [tokenID, setTokenID] = useState(0);
    const [metadataURI, setMetaDataURI] = useState("");


    useEffect(() => {
        const updateYourCollectibles = async () => {
            const collectibleUpdate = [];
            let img = "";
            try {
                // const balance = await readContracts.CanvasNFT.getNFTCount();
                // console.log("balance of ", parseInt(balance));
                img = await readContracts.CanvasNFT.getCanvasImage();

                // for (let tokenIndex = 0; tokenIndex < balance; tokenIndex++) {

                //     const tokenURI = await readContracts.CanvasNFT.tokenURI(tokenIndex);
                //     const ownerAddress = await readContracts.CanvasNFT.ownerOf(tokenIndex);
                //     const jsonManifestString = atob(tokenURI.substring(29));

                //     try {
                //         const jsonManifest = JSON.parse(jsonManifestString);
                //         collectibleUpdate.push({ id: tokenIndex, uri: tokenURI, owner: ownerAddress, ...jsonManifest });
                //     } catch (e) {
                //         console.log(e);
                //     }
                // }
            }
            catch (e) {
                console.log(e);
            }
            setYourCollectibles(collectibleUpdate.reverse());
            setCanvasImage(img)
        };
        updateYourCollectibles();
    }, [address, yourMainnetBalance, yourLocalBalance]);

    const fallbackImg =
        "data:image/png;base64,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";
    return (
        <div>
            {/*
        ⚙️ Here is an example UI that displays and sets the purpose in your smart contract:
      */}
            <div style={{ border: "1px solid #cccccc", padding: 16, width: 400, margin: "auto", marginTop: 64 }}>
                <h2>Mint Canvas NFT:</h2>
                <Image
                    src={canvasImage}
                    fallbackImg={fallbackImg}
                    alt="canvas image"
                />
                <div style={{ margin: 8 }}>
                    <Button
                        style={{ marginTop: 8 }}
                        onClick={async () => {
                            const priceRightNow = await readContracts.CanvasNFT.price();
                            const contractAddress = await readContracts.PixelNFT.address;
                            const color = await readContracts.PixelNFT.getColor(tokenID);
                            const result = tx(writeContracts.CanvasNFT.placePixel(x, y, color, contractAddress, tokenID), update => {
                                console.log("📡 Transaction Update:", update);
                                if (update && (update.status === "confirmed" || update.status === 1)) {
                                    console.log(" 🍾 Transaction " + update.hash + " finished!");
                                    console.log(
                                        " ⛽️ " +
                                        update.gasUsed +
                                        "/" +
                                        (update.gasLimit || update.gas) +
                                        " @ " +
                                        parseFloat(update.gasPrice) / 1000000000 +
                                        " gwei",
                                    );
                                }
                            });
                            console.log("awaiting metamask/web3 confirm result...", result);
                            console.log(await result);
                        }}
                    >
                        place pixel in canvas NFT
                    </Button>
                </div>
                <div style={{ margin: 8 }}>
                    <h2>Place Pixel</h2>
                    <h2>X</h2>
                    <Input type="number" max={4} min={0}
                        onChange={e => {
                            setX(e.target.value);
                        }}
                    />

                    <h2>Y</h2>

                    <Input type="number" max={4} min={0}
                        onChange={e => {
                            setY(e.target.value);
                        }}
                    />

                    <h2>Token ID from PIXEL NFT</h2>

                    <Input type="number" min={0}
                        onChange={e => {
                            setTokenID(e.target.value);
                        }}
                    />

                </div>

                <Divider />
                <div style={{ margin: 8 }}>
                    <Button
                        style={{ marginTop: 8 }}
                        onClick={async () => {
                            /* look how you call setPurpose on your contract: */
                            /* notice how you pass a call back for tx updates too */

                            const options = {
                              method: 'POST',
                              url: 'https://api.nftport.xyz/v0/metadata',
                              headers: {
                                'Content-Type': 'application/json',
                                Authorization: '7691f6a6-916b-4d40-8970-66c6df1e2eb5'
                              },
                              data: {
                                name: 'My Art',
                                description: 'This is my custom art piece',
                                file_url: canvasImage
                              }
                            };
                            
                            axios.request(options).then(function (response) {
                              console.log(response.data.metadata_uri);
                              setMetaDataURI(response.data.metadata_uri)

                            }).catch(function (error) {
                              console.error(error);
                            });

                            const priceRightNow = await readContracts.CanvasNFT.price();
                            const result = tx(writeContracts.CanvasNFT.mintItem(metadataURI, { value: priceRightNow }), update => {
                                console.log("📡 Transaction Update:", update);
                                if (update && (update.status === "confirmed" || update.status === 1)) {
                                    console.log(" 🍾 Transaction " + update.hash + " finished!");
                                    console.log(
                                        " ⛽️ " +
                                        update.gasUsed +
                                        "/" +
                                        (update.gasLimit || update.gas) +
                                        " @ " +
                                        parseFloat(update.gasPrice) / 1000000000 +
                                        " gwei",
                                    );
                                }
                            });
                            console.log("awaiting metamask/web3 confirm result...", result);
                            console.log(await result);
                        }}
                    >
                        mint now for 0.001 ETH
                    </Button>
                </div>
                <Divider />
                Your Address:
                <Address address={address} ensProvider={mainnetProvider} fontSize={16} />
                <Divider />
                <h2>Your Balance: {yourLocalBalance ? utils.formatEther(yourLocalBalance) : "..."}</h2>
                <div>OR</div>
                <Balance address={address} provider={localProvider} price={price} />
                {/* <Divider /> */}
                {/* <h2>Your Balance: {yourMainnetBalance ? utils.formatEther(yourMainnetBalance) : "..."}</h2>
        <div>OR</div>
        <Balance address={address} provider={mainnetProvider} price={price} />
        <Divider /> */}
            </div>
            {/* <div style={{ width: 820, margin: "auto", paddingBottom: 256 }}>
                <List
                    bordered
                    dataSource={yourCollectibles}
                    renderItem={item => {
                        const id = item.id;

                        return (
                            <List.Item key={id + "_" + item.uri + "_" + item.owner}>
                                <Card
                                    title={
                                        <div>
                                            <span style={{ fontSize: 18, marginRight: 8 }}>{item.name}</span>
                                        </div>
                                    }
                                >
                                    <img src={item.image} alt={"Pixel #" + id} />
                                    <div>{item.description + "\nPixel #" + id}</div>
                                </Card>

                                <div>
                                    owner:{" "}
                                    <Address
                                        address={item.owner}
                                        ensProvider={mainnetProvider}
                                        fontSize={16}
                                    />
                                </div>
                            </List.Item>
                        );
                    }}
                />
            </div> */}
        </div>
    );
}
