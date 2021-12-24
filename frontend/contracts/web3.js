import Web3 from "web3";

const getWeb3 = () =>
  new Promise((resolve) => {
    window.addEventListener("load", () => {
      let currentWeb3;

      if (window.ethereum) {
        currentWeb3 = new Web3(window.ethereum);
        currentWeb3.eth.requestAccounts()
          .then(() => {
            resolve(currentWeb3);
          })
          .catch(() => alert("Please allow access for the app to work"));
      } else if (window.web3) {
        window.web3 = new Web3(window.web3.currentProvider);
        // Acccounts always exposed
        resolve(currentWeb3);
      } else {
        console.log(
          "Non-Ethereum browser detected. You should consider trying MetaMask!"
        );
      }
    });
  });

export default getWeb3;
