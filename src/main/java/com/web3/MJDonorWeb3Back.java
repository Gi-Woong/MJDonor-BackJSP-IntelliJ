package com.web3;

import com.web3.contracts.DonationContract;
import com.web3.contracts.DonationToken;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.gas.DefaultGasProvider;

import java.math.BigInteger;


public class MJDonorWeb3Back {
    private static final java.util.ResourceBundle resource = java.util.ResourceBundle.getBundle("config");
    private final static String nodeUrl = System.getenv().getOrDefault("WEB3J_NODE_URL", resource.getString("web3.networkUrl"));
    private final DefaultGasProvider defaultGasProvider = new DefaultGasProvider();
    private DonationToken donationToken;
    private final Web3j web3j = Web3j.build(new HttpService(nodeUrl));
//   private static final String walletPassword = System.getenv().getOrDefault("WEB3J_WALLET_PASSWORD", "<wallet_password>");
//   private static final String walletPath = System.getenv().getOrDefault("WEB3J_WALLET_PATH", "<wallet_path>");
    private final String account = resource.getString("web3.account");
    private final Credentials credentials;


    public MJDonorWeb3Back() {
//        nodeUrl = System.getenv().getOrDefault("WEB3J_NODE_URL", "http://127.0.0.1:8545");
//        web3j = Web3j.build(new HttpService(nodeUrl));
//        defaultGasProvider = new DefaultGasProvider();

//        account = resource.getString("web3.account");
        this.credentials = Credentials.create(resource.getString("web3.privateKey"));
    }

    public TransactionReceipt deployDonationContract(String privateKey, String targetPoint, String donationPeriodInDays) throws Exception{
        DonationContract donationContract = DonationContract.deploy(web3j,
                Credentials.create(privateKey),
                new DefaultGasProvider(),
                donationToken.getContractAddress(),
                BigInteger.valueOf(Long.parseLong(targetPoint)),
                BigInteger.valueOf(Long.parseLong(donationPeriodInDays))).send();
        System.out.println("Contract address: " + donationContract.getContractAddress());
        return donationContract.getTransactionReceipt().get();
    }

    //overload
    public TransactionReceipt deployDonationContract(String targetPoint, String donationPeriodInDays) throws Exception {
        System.out.println(targetPoint);
        System.out.println(Long.parseLong(donationPeriodInDays));
        DonationContract donationContract = DonationContract.deploy(web3j,
                credentials,
                defaultGasProvider,
                donationToken.getContractAddress(),
                BigInteger.valueOf(Long.parseLong(targetPoint)),
                BigInteger.valueOf(Long.parseLong(donationPeriodInDays))).send();
        System.out.println("Contract address: " + donationContract.getContractAddress());
        System.out.println("Transaction Receipt:"+ donationContract.getTransactionReceipt());
        return donationContract.getTransactionReceipt().get();
    }

    public TransactionReceipt donate(String privateKey, DonationContract donationContract, BigInteger amount) throws Exception {
//        DonationToken donationToken1 = DonationToken.load(donationToken.getContractAddress(), web3j, Credentials.create(privateKey), defaultGasProvider);
        String tokenContractAddress = donationContract.tokenContract().send();
        DonationToken donationToken = DonationToken.load(tokenContractAddress, web3j, credentials, defaultGasProvider);
        TransactionReceipt approveTransaction = donationToken.approve(donationContract.getContractAddress(), amount).send();
        return donationContract.donate(amount).send();
    }
    //overload
    public TransactionReceipt donate(String donationContractAddress, BigInteger amount) throws Exception {
        DonationContract donationContract = DonationContract.load(donationContractAddress, web3j, credentials, defaultGasProvider);
        String tokenContractAddress = donationContract.tokenContract().send();
        DonationToken donationToken = DonationToken.load(tokenContractAddress, web3j, credentials, defaultGasProvider);
        TransactionReceipt approveTransaction = donationToken.approve(donationContract.getContractAddress(), amount).send();
        return donationContract.donate(amount).send();
    }

    public TransactionReceipt refund(String donationContractAddress) throws Exception {
        DonationContract donationContract = DonationContract.load(donationContractAddress, web3j, credentials, defaultGasProvider);
        return donationContract.refund().send();
    }
}
