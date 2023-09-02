<%@ page import="com.web3.MJDonorWeb3Back"%>
<%@ page import="com.db.ConnectDB"%>
<%@ page import="java.util.Map" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
  ConnectDB connectDB = ConnectDB.getInstance();
  // 한글 인코딩 부분
  String v_a = "하나/X9891214755337";
  Map<String, Object> depositedMap = connectDB.confirmToBlockchain(v_a);

  if (depositedMap.isEmpty()) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); //404
  }
  JSONObject json = new JSONObject();
  json.putAll(depositedMap);
  out.print(json.toJSONString());
%>
