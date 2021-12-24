<template>
  <div class="hello">
    <h1>Hallo NFT</h1>
    <p>{{ account }}</p>
    <div >
      <button class="btn btn-light" type="button" v-on:click="showMyNft($event)">
        All NFT
      </button>
      <button class="btn btn-primary" type="button" v-on:click="showMyNft($event)">
        My NFT
      </button>
    </div>
    
    <div class="container">
      <div class="nft-wrapper d-flex flex-wrap justify-content-center">
        <div v-for="item in arrNFT" :key="item.key" class="card m-2" style="width: 18rem;">
          <img :src="baseUrl + item.image" class="card-img-top" alt="">
          <div class="card-body">
            <h5 class="card-title">{{ item.name }}</h5>
            <p class="card-text">{{ item.desc }}</p>
            <a href="#" v-on:click="buyNft($event, item)" class="btn btn-primary text-white">Buy (0.003 ETH)</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import getWeb3 from '../../contracts/web3';
import contractAbi from '../../contracts/abi';

 
const contractAddress = '0x628be8B822EbB1C4bDb0dd1AdD3f31384273F247';
const baseUrl = "http://localhost:8000/";

export default {
  name: 'HelloWorld', 
  data: function() {
    return {
      arrNFT: [],
      baseUrl: baseUrl,

      web3: null,
      account: null,
      contractInstance: null,
      isLoading: false,
    }
  },
  mounted: function() {
    axios.get(baseUrl + "api/nftmeta")
      .then((response) => {this.arrNFT = response.data});

    getWeb3().then((res) => {
      this.web3 = res;
      this.contractInstance = new this.web3.eth.Contract(contractAbi, contractAddress);
      this.web3.eth.getAccounts().then((accounts) => {
        [this.account] = accounts;
        // this.getVipers();
      }).catch((err) => {
        console.log(err, 'err!!');
      });
    });
  },

  methods: {
    buyNft: function(e, item) {
      e.preventDefault();
      this.isLoading = true;
      this.contractInstance.methods.buyNFT(item.id).send({
        from: this.account,
        value: this.web3.utils.toWei('0.003', 'ether'),
      }).then(async function (receipt) {
        const tokenUri = await this.contractInstance.methods.getNftDetails(receipt);
        console.log(tokenUri);
        this.isLoading = false;
      }).catch((err) => {
        console.log(err, 'err');
        this.isLoading = false;
      });

    },

    showMyNft: function(e) {
      e.preventDefault();

      let self = this;
      this.isLoading = true;
      this.contractInstance.methods.ownedNft().call({
        from: this.account,
      }).then(async function(receipt) {
        console.log(receipt);
        for (let i = 0; i < receipt.length; i += 1) {
          self.contractInstance.methods.getNftDetails(receipt[i]).call({
            from: self.account
          }).then((uri) => {
            console.log(uri);
          });
        }

        // for (let i = 0; i < receipt.length; i += 1) {
        //   const { data } = await this.contractInstance.methods.tokenURI(receipt);
        //   console.log(data);

        //   this.contractInstance.methods.tokenURI(receipt[i]).call({
        //     from: this.account,
        //   }).then((token) => {
        //     console.log(viper);

        //   }).catch((err) => {
        //     console.log(err, 'err');
        //   });
        // }
        // this.isLoading = false;
      }).catch((err) => {
        console.log(err, 'err');
        this.isLoading = false;
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
