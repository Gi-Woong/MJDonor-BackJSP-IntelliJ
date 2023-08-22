package com.web3.contracts;

import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.RemoteFunctionCall;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.gas.ContractGasProvider;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 4.10.1.
 */
@SuppressWarnings("rawtypes")
public class DonationContract extends Contract {
    public static final String BINARY = "608060405234801561000f575f80fd5b5060405161094838038061094883398101604081905261002e91610085565b5f80546001600160a01b03191633179055600282905561005181620151806100d8565b61005b90426100f5565b6003555050600180546001600160a01b0319166001600160a01b0392909216919091179055610108565b5f805f60608486031215610097575f80fd5b83516001600160a01b03811681146100ad575f80fd5b602085015160409095015190969495509392505050565b634e487b7160e01b5f52601160045260245ffd5b80820281158282048414176100ef576100ef6100c4565b92915050565b808201808211156100ef576100ef6100c4565b610833806101155f395ff3fe608060405260043610610087575f3560e01c806359abef9a1161005757806359abef9a146101985780638da5cb5b146101ac578063ac4df041146101ca578063f12a4a53146101f3578063f14faf6f14610208575f80fd5b8063022f6388146100f85780632b8792321461013657806355a373d61461014b578063590e1ae314610182575f80fd5b366100f45760405162461bcd60e51b815260206004820152603260248201527f5468697320636f6e7472616374206f6e6c792061636365707473204552432d3260448201527118103a37b5b2b7103237b730ba34b7b7399760711b60648201526084015b60405180910390fd5b5f80fd5b348015610103575f80fd5b5061012361011236600461075e565b60056020525f908152604090205481565b6040519081526020015b60405180910390f35b348015610141575f80fd5b5061012360025481565b348015610156575f80fd5b5060015461016a906001600160a01b031681565b6040516001600160a01b03909116815260200161012d565b34801561018d575f80fd5b50610196610227565b005b3480156101a3575f80fd5b5061019661035b565b3480156101b7575f80fd5b505f5461016a906001600160a01b031681565b3480156101d5575f80fd5b506004546101e39060ff1681565b604051901515815260200161012d565b3480156101fe575f80fd5b5061012360035481565b348015610213575f80fd5b5061019661022236600461078b565b610562565b60045460ff166102725760405162461bcd60e51b8152602060048201526016602482015275111bdb985d1a5bdb881a5cc81b9bdd0818db1bdcd95960521b60448201526064016100eb565b335f81815260056020526040808220805492905560015490516323b872dd60e01b815230600482015260248101939093526044830182905290916001600160a01b03909116906323b872dd906064016020604051808303815f875af11580156102dd573d5f803e3d5ffd5b505050506040513d601f19601f8201168201806040525081019061030191906107a2565b6103585760405162461bcd60e51b815260206004820152602260248201527f4661696c656420746f207472616e7366657220746f6b656e7320746f20646f6e60448201526137b960f11b60648201526084016100eb565b50565b5f546001600160a01b031633146103cb5760405162461bcd60e51b815260206004820152602e60248201527f4f6e6c792074686520636f6e7472616374206f776e65722063616e2063616c6c60448201526d103a3434b990333ab731ba34b7b760911b60648201526084016100eb565b60045460ff161561041e5760405162461bcd60e51b815260206004820181905260248201527f446f6e6174696f6e2068617320616c7265616479206265656e20636c6f73656460448201526064016100eb565b6001546040516370a0823160e01b81523060048201525f916001600160a01b0316906370a0823190602401602060405180830381865afa158015610464573d5f803e3d5ffd5b505050506040513d601f19601f8201168201806040525081019061048891906107c1565b905060025481106105525760015460405163a9059cbb60e01b81526001600160a01b0390911660048201819052602482018390529063a9059cbb906044016020604051808303815f875af11580156104e2573d5f803e3d5ffd5b505050506040513d601f19601f8201168201806040525081019061050691906107a2565b6105525760405162461bcd60e51b815260206004820152601d60248201527f4661696c656420746f2073656e6420646f6e6174656420746f6b656e7300000060448201526064016100eb565b506004805460ff19166001179055565b60045460ff16156105b55760405162461bcd60e51b815260206004820152601860248201527f446f6e6174696f6e20686173206265656e20636c6f736564000000000000000060448201526064016100eb565b60035442106106065760405162461bcd60e51b815260206004820152601960248201527f446f6e6174696f6e20706572696f642068617320656e6465640000000000000060448201526064016100eb565b5f81116106665760405162461bcd60e51b815260206004820152602860248201527f446f6e6174696f6e20616d6f756e742073686f756c6420626520677265617465604482015267072207468616e20360c41b60648201526084016100eb565b6001546040516323b872dd60e01b8152336004820152306024820152604481018390526001600160a01b03909116906323b872dd906064016020604051808303815f875af11580156106ba573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906106de91906107a2565b6107385760405162461bcd60e51b815260206004820152602560248201527f4661696c656420746f207472616e7366657220746f6b656e7320746f20636f6e6044820152641d1c9858dd60da1b60648201526084016100eb565b335f90815260056020526040812080548392906107569084906107d8565b909155505050565b5f6020828403121561076e575f80fd5b81356001600160a01b0381168114610784575f80fd5b9392505050565b5f6020828403121561079b575f80fd5b5035919050565b5f602082840312156107b2575f80fd5b81518015158114610784575f80fd5b5f602082840312156107d1575f80fd5b5051919050565b808201808211156107f757634e487b7160e01b5f52601160045260245ffd5b9291505056fea264697066735822122098ef9c8ed9a35155f2bd981ba593ba4fcc85a2cd0aadbe1611790ff1be93778964736f6c63430008140033";

    public static final String FUNC_CLOSEDONATION = "closeDonation";

    public static final String FUNC_DONATE = "donate";

    public static final String FUNC_DONATEDAMOUNT = "donatedAmount";

    public static final String FUNC_DONATIONCLOSED = "donationClosed";

    public static final String FUNC_DONATIONENDTIME = "donationEndTime";

    public static final String FUNC_OWNER = "owner";

    public static final String FUNC_REFUND = "refund";

    public static final String FUNC_TARGETPOINT = "targetPoint";

    public static final String FUNC_TOKENCONTRACT = "tokenContract";

    @Deprecated
    protected DonationContract(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected DonationContract(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected DonationContract(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected DonationContract(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public RemoteFunctionCall<TransactionReceipt> closeDonation() {
        final Function function = new Function(
                FUNC_CLOSEDONATION, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> donate(BigInteger amount) {
        final Function function = new Function(
                FUNC_DONATE, 
                Arrays.<Type>asList(new Uint256(amount)),
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> donatedAmount(String param0) {
        final Function function = new Function(FUNC_DONATEDAMOUNT, 
                Arrays.<Type>asList(new Address(160, param0)),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Boolean> donationClosed() {
        final Function function = new Function(FUNC_DONATIONCLOSED, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<BigInteger> donationEndTime() {
        final Function function = new Function(FUNC_DONATIONENDTIME, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<String> owner() {
        final Function function = new Function(FUNC_OWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<TransactionReceipt> refund() {
        final Function function = new Function(
                FUNC_REFUND, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> targetPoint() {
        final Function function = new Function(FUNC_TARGETPOINT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<String> tokenContract() {
        final Function function = new Function(FUNC_TOKENCONTRACT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    @Deprecated
    public static DonationContract load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new DonationContract(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static DonationContract load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new DonationContract(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static DonationContract load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new DonationContract(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static DonationContract load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new DonationContract(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<DonationContract> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider, String _tokenContract, BigInteger _targetPoint, BigInteger _donationPeriodInDays) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new Address(160, _tokenContract),
                new Uint256(_targetPoint),
                new Uint256(_donationPeriodInDays)));
        return deployRemoteCall(DonationContract.class, web3j, credentials, contractGasProvider, BINARY, encodedConstructor);
    }

    public static RemoteCall<DonationContract> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider, String _tokenContract, BigInteger _targetPoint, BigInteger _donationPeriodInDays) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new Address(160, _tokenContract),
                new Uint256(_targetPoint),
                new Uint256(_donationPeriodInDays)));
        return deployRemoteCall(DonationContract.class, web3j, transactionManager, contractGasProvider, BINARY, encodedConstructor);
    }

    @Deprecated
    public static RemoteCall<DonationContract> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit, String _tokenContract, BigInteger _targetPoint, BigInteger _donationPeriodInDays) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new Address(160, _tokenContract),
                new Uint256(_targetPoint),
                new Uint256(_donationPeriodInDays)));
        return deployRemoteCall(DonationContract.class, web3j, credentials, gasPrice, gasLimit, BINARY, encodedConstructor);
    }

    @Deprecated
    public static RemoteCall<DonationContract> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit, String _tokenContract, BigInteger _targetPoint, BigInteger _donationPeriodInDays) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new Address(160, _tokenContract),
                new Uint256(_targetPoint),
                new Uint256(_donationPeriodInDays)));
        return deployRemoteCall(DonationContract.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, encodedConstructor);
    }
}
