<%@page import="com.db.ConnectDB" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.web3.MJDonorWeb3Back" %>
<%@ page import="com.web3.MJDonorWeb3Back" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.web3j.protocol.core.methods.response.TransactionReceipt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
    ConnectDB connectDB = ConnectDB.getInstance();

    // 한글 인코딩 부분
    request.setCharacterEncoding("utf-8");

    // Get registration parameters from request
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    int target_point = Integer.parseInt(request.getParameter("target_point"));

    String start_date = request.getParameter("start_date");
    String end_date = request.getParameter("end_date");

    String image1 = request.getParameter("image1");
    String image2 = request.getParameter("image2");

    String category = request.getParameter("category");

    int ORGANIZATION_ID = Integer.parseInt(request.getParameter("ORGANIZATION_ID"));
    int REGISTRANT_ID = Integer.parseInt(request.getParameter("REGISTRANT_ID"));

    // 두 날짜간 차이 계산
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    Long dateDifference =
            ChronoUnit.DAYS.between(
                    LocalDate.parse(start_date, formatter),
                    LocalDate.parse(end_date, formatter));

    // deploy new DonationContract
    MJDonorWeb3Back mjDonorWeb3 = new MJDonorWeb3Back();
    TransactionReceipt donationContractReceipt;
    try {
        donationContractReceipt = mjDonorWeb3.deployDonationContract(
                request.getParameter("target_point"),
                String.valueOf(dateDifference));
    } catch (Exception e) {
        throw new RuntimeException(e);
    }

    String resultMessage = connectDB.performRegister(name, description, target_point, start_date, end_date, image1, image2, category, ORGANIZATION_ID, REGISTRANT_ID, donationContractReceipt.getContractAddress());

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("status", "success");
    jsonObject.put("validation", "success");
    jsonObject.put("donationContractAddress", donationContractReceipt.getTransactionHash())

    // 안드로이드로 전송
    out.print(jsonObject.toJSONString());
%>
