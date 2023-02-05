import React, { useState } from "react";
import Web3 from 'web3';
import './App.css';
import blockchainlogo from './blockchain_logo-removebg-preview.png';
import js_logo from './js logo.png';
import homeicon from './home.png';
import python_logo from './python logo.jpg';
import solidity_logo from './solidity logo.png';
import rustlogo from './rust logo.png';
import webtri from './web3.jpg';
import abi from "./build/contracts/blockchaintabs.json";

function App() {

  const web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
  // import the IPFS HTTP Client
const IPFS = require("ipfs-http-client");

// create an instance of the IPFS HTTP Client
const ipfs = IPFS({ host: "ipfs.infura.io", port: "5001", protocol: "https" });

let contractAddress = "0xEE09cAB29488eA6dFc0c31e4a83165438a3a3b47";
let loading = false;


const ContractFunction = () => {
  const [imgHash, setImgHash] = useState("");
  const [content, setContent] = useState("");
  const [imageData, setImageData] = useState([]);
  const [loading, setLoading] = useState(true);

  const handleSubmit = async (event) => {
    event.preventDefault();

    setLoading(true);

    const accounts = await web3.eth.getAccounts();

    // load the contract instance
    const contract = new web3.eth.Contract(abi,contractAddress);

    // call the contract function
    contract.methods
      .uploadImage(imgHash, content)
      .send({ from: accounts[0] })
      .then((result) => {
        console.log("Success", result);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error", error);
        setLoading(false);
      });
  };

  const handleFileChange = async (event) => {
    const file = event.target.files[0];
  
    const buf = await buffer(file);
    const ipfsHash = await addToIpfs(buf);
  
    // set the imgHash state with the IPFS hash of the file
    setImgHash(ipfsHash);
  };
  
  async function buffer(reader) {
    return new Promise((resolve, reject) => {
      const buffer = [];
      reader.on("data", (chunk) => buffer.push(chunk));
      reader.on("end", () => resolve(Buffer.concat(buffer)));
      reader.on("error", reject);
    });
  }
  
  async function addToIpfs(content) {
    const result = await ipfs.add(content);
    return result[0].hash;
  }

  
  const getImageData = async () => {
    const imageCount = await contract.methods.imageCount().call();

    const imageDataArray = [];
    for (let i = 1; i <= imageCount; i++) {
      const image = await contract.methods.images(i).call();
      imageDataArray.push(image);
    }
    setImageData(imageDataArray);
    setLoading(false);
  };

  useEffect(() => {
    getImageData();
  }, []);
 


  return (
    <div className="App">
      {loading ? <div>Loading...</div> : null}
        <header>
      <img src={blockchainlogo} id="logop" alt='bc logo'/>
      <h2 id="label">blockchain tabs</h2>
      <a href="index.html">
        <img src={homeicon} alt="Home" id="home" />
        <span className="tooltiptext">Home</span>
      </a>
      

      <input type="text" placeholder="Search.." />
    </header>
    <nav>
      <div id="spaces">
        <h3>Spaces:</h3>
        <ul>
          <li>
            <img src={python_logo}  alt="python" /> <br />
            Python
          </li>
          <li>
            <img src={js_logo} alt="js" /> <br />
            Javascript
          </li>
          <li>
            <img src={solidity_logo} alt="solidity" /> <br />
            Solidity
          </li>
          <li>
            <img src={rustlogo} alt="rust" /> <br />
            Rust
          </li>
          <li>
            <img src={webtri}   alt="web3" /> <br />
            Web3
          </li>
        </ul>
      </div>
    </nav>
    <article> 
     {imageData.map((image) => (
          <div key={image.id}>
            <p>Image ID: {image.id}</p>
            <p>Image Hash: {image.hash}</p>
            <p>Image Content: {image.content}</p>
            <p>Author: {image.author}</p>
          </div>
    ))}
    </article>
    <section>
      <div id="modal">
        <h3>Post your article</h3>
        <h4 style={{ color: "rgb(226, 79, 79)" }}>
          Share your knowledge with the community!
        </h4>
        <form onSubmit={handleSubmit}>
      <textarea name="article" dirName="article.dir" onChange={(e) => setContent(e.target.value)} />
      <label> Attach an image</label>
      <input type="file" name="file" id="file" multiple="multiple" onChange={handleFileChange} />
      <input type="submit" id="subm" name="submit" value="Post" />
    </form>
      </div>
    </section>
     
    </div>
  );
}}

export default App;
