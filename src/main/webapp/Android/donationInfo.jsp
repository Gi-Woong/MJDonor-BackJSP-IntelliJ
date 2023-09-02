<%@page import="com.db.ConnectDB"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    ConnectDB connectDB = ConnectDB.getInstance();

    // 한글 인코딩 부분
    request.setCharacterEncoding("utf-8");

    // Retrieve donation info based on parameters
    String pIdParam = request.getParameter("p_id");
    String nickname = request.getParameter("nickname");
    String pointParam = request.getParameter("point");

    if (pIdParam != null && nickname != null && pointParam != null) {
        int pId = Integer.parseInt(pIdParam);
        double point = Double.parseDouble(pointParam);
        String donationInfo = connectDB.getDonationInfo(pId, nickname, point);
        out.println(donationInfo);
    }
%>
