<%@ page import="com.db.ConnectDB" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.web3.MJDonorWeb3Back" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="org.web3j.protocol.core.methods.response.TransactionReceipt" %>
<%@ page import="com.web3.contracts.DonationToken" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String isSuccess = request.getParameter("isSuccess");
  String v_a = request.getParameter("virtual_account");
  if (Boolean.parseBoolean(isSuccess)) {
    ConnectDB connectDB = ConnectDB.getInstance();
    Map<String, Object> getPointBlockChainMap = connectDB.getPointBlockchain(v_a);
    String walletAddr = getPointBlockChainMap.get("wallet").toString();
    long point = Long.parseLong(getPointBlockChainMap.get("point").toString());
    MJDonorWeb3Back mjDonorWeb3Back = new MJDonorWeb3Back();
    try {
      TransactionReceipt transactionReceipt = mjDonorWeb3Back.donationToken.transfer(walletAddr, BigInteger.valueOf(point)).sendAsync().get();
      out.println(transactionReceipt.toString());
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }
//  out.println(Boolean.valueOf(isSuccess));
%>
