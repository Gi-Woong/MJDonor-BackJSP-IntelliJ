<%@ page import="com.db.ConnectDB" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String v_a = request.getParameter("virtual_account");
    ConnectDB connectDB = ConnectDB.getInstance();
    connectDB.deposit(v_a, 2);
    connectDB.updateCurrent(v_a);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script>
        alert('저희 플랫폼을 통해 기부해주셔서 감사합니다!');
    </script>
    <style>
        .container {
            text-align: center;
        }

        .donate {
            padding: 10px 20px;
            font-size: 16px;
            background: dimgrey; /* 그라데이션 배경 */
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            display: inline-block;
        }

        /* 미디어 쿼리를 사용하여 화면 크기에 따른 버튼 크기 조정 */
        @media (max-width: 1000px) {
            .button {
                padding: 5px 10px;
                font-size: 16px;
                border-radius: 5px;
            }
        }
    </style>
    <title>Document</title>
</head>
<body>
<div class="container">
    <button class="donate" style="">기부가 확정되었습니다.</button>
    <p>저희 플랫폼을 통해 기부해주셔서 감사합니다!</p>
</div>
</body>
</html>
