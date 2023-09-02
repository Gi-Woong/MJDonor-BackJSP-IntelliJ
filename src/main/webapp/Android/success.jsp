<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Base64.Encoder" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.Reader" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.web3.MJDonorWeb3Back" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.db.ConnectDB" %>
<%@ page import="java.math.BigInteger" %>

<%
    // 결제 승인 API 호출하기

    String orderId = request.getParameter("orderId");
    String paymentKey = request.getParameter("paymentKey");
    String amount = request.getParameter("amount");
    String v_a = request.getParameter("virtual_account");
    String secretKey = "test_sk_0Poxy1XQL8R5oDbgbk9r7nO5Wmlg:";

    Encoder encoder = Base64.getEncoder();
    byte[] encodedBytes = encoder.encode(secretKey.getBytes(StandardCharsets.UTF_8));
    String authorizations = "Basic " + new String(encodedBytes);

    paymentKey = URLEncoder.encode(paymentKey, StandardCharsets.UTF_8);

    URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");

    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setRequestProperty("Authorization", authorizations);
    connection.setRequestProperty("Content-Type", "application/json");
    connection.setRequestMethod("POST");
    connection.setDoOutput(true);
    JSONObject obj = new JSONObject();
    obj.put("paymentKey", paymentKey);
    obj.put("orderId", orderId);
    obj.put("amount", amount);

    OutputStream outputStream = connection.getOutputStream();
    outputStream.write(obj.toString().getBytes(StandardCharsets.UTF_8));

    int code = connection.getResponseCode();
    boolean isSuccess = code == 200;
    InputStream responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();
    Reader reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);
    JSONParser parser = new JSONParser();
    JSONObject jsonObject = (JSONObject) parser.parse(reader);
    responseStream.close();
    // 블록체인 토큰(포인트) 지급
    if (isSuccess) {
        String virtualAccount =
                ((JSONObject) jsonObject.get("transfer")).get("bank").toString() +
                "/" +
                ((JSONObject) jsonObject.get("virtualAccount")).get("accountNumber").toString();
        ConnectDB connectDB = ConnectDB.getInstance();
        Map<String, Object> getPointBlockChainMap = connectDB.getPointBlockchain(virtualAccount);
        String walletAddr = getPointBlockChainMap.get("wallet").toString();
        long point = Long.parseLong(getPointBlockChainMap.get("point").toString());
        MJDonorWeb3Back mjDonorWeb3Back = new MJDonorWeb3Back();
        try {
            mjDonorWeb3Back.transfer(walletAddr, BigInteger.valueOf(point));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <title>결제 성공</title>
    <meta http-equiv="x-ua-compatible" content="ie=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
</head>
<body>
<section>
    <%
        if (isSuccess) { %>
    <h1>결제 성공</h1>
    <p>결과 데이터 : <%= jsonObject.toJSONString() %>
    </p>
    <p>orderName : <%= jsonObject.get("orderName") %>
    </p>
    <p>method : <%= jsonObject.get("method") %>
    </p>
    <p>
        <% if (jsonObject.get("method").equals("카드")) {
            out.println(((JSONObject) jsonObject.get("card")).get("number"));
        } %>
        <% if (jsonObject.get("method").equals("가상계좌")) {
            out.println(((JSONObject) jsonObject.get("virtualAccount")).get("accountNumber"));
        } %>
        <% if (jsonObject.get("method").equals("계좌이체")) {
            out.println(((JSONObject) jsonObject.get("transfer")).get("bank"));
        } %>
        <% if (jsonObject.get("method").equals("휴대폰")) {
            out.println(((JSONObject) jsonObject.get("mobilePhone")).get("customerMobilePhone"));
        } %>

    </p>

    <%} else { %>
    <h1>결제 실패</h1>
    <p><%= jsonObject.get("message") %>
    </p>
    <span>에러코드: <%= jsonObject.get("code") %></span>
    <%
        }
    %>

</section>
</body>
</html>
