// import Web3 from "web3";
import Metamask from "./metamask.js";

let bytecodeDonation;
let abiDonation;
let abiDonationToken;

//index.html의 실행 위치에 따른 상대경로
const importData = async () => {
  bytecodeDonation = "./assets/DonationContract.txt";
  abiDonation = await fetch("./assets/DonationContract.json").then(
    (res) => res.json()
  );
  abiDonationToken = await fetch("./assets/DonationToken.json").then(
    (res) => res.json()
  );
  console.log(abiDonationToken);
};

const metamask = new Metamask();

export const init = async () => {
  await metamask.init();
  await importData();
  // console.log(abiSeller);
  // console.log(abiSettle);
};

export const logAccount = async () => {
  const account = metamask.account;
  const balance = await metamask.web3.eth.getBalance(account);
  console.log(`Account: ${account}\nBalance: ${balance}`);
};

export const donationToken = {
  instance: null,
  load: (donationTokenAddr) => {
    donationToken.instance = new metamask.web3.eth.Contract(
      abiDonationToken,
      donationTokenAddr
    );
    donationToken.instance.setProvider(metamask.web3Provider);
    console.log("donationToken contract loaded:");
    console.log(donationToken.instance);
  },
  approve: async (spender, amount) => {
    return await donationToken.instance.methods.approve(spender, amount).send({
      from: metamask.account,
    });
  },
};

export const donationContract = {
  instance: null,
  load: (donationAddr) => {
    donationContract.instance = new metamask.web3.eth.Contract(
      abiDonation,
      donationAddr
    );
    donationContract.instance.setProvider(metamask.web3Provider);
    console.log("donation contract loaded:");
    console.log(donationContract.instance);
  },
  donate: async (amount) => {
    return await donationContract.instance.methods.donate(amount).send({
      from: metamask.account,
    });
  },
};

