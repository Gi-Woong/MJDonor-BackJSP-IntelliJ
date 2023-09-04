<%@ page import="com.web3.MJDonorWeb3Back"%>
<%@ page import="com.db.ConnectDB"%>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  ConnectDB connectDB = ConnectDB.getInstance();
  // 한글 인코딩 부분
  request.setCharacterEncoding("utf-8");
  String v_a = request.getParameter("virtual_account");
  Map<String, Object> depositedMap = connectDB.confirmToBlockchain(v_a);

  if (depositedMap.isEmpty()) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "depositedMap is Empty"); //404
  }
  int point = Integer.parseInt(depositedMap.get("point").toString());
  String donationContractAddr = depositedMap.get("contract_address").toString();
  MJDonorWeb3Back mjDonorWeb3Back = new MJDonorWeb3Back();
  String donationTokenAddr = mjDonorWeb3Back.donationToken.getContractAddress();
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.jsdelivr.net/npm/@metamask/detect-provider@1.2.0/dist/detect-provider.min.js"></script>
    <!-- <script src="./js/@metamask-detect-provider_v1.2.0_min.js"></script> -->
    <script src="https://cdn.jsdelivr.net/npm/web3@1.7.5/dist/web3.min.js"></script>
    <script type="module" src="./js/contracts.js"></script>
    <script type="module">
      import * as ca from "./js/contracts.js";
      ca.init().then(() => {
        const donationTokenAddr = "<%=donationTokenAddr%>"
        const donationContractAddr = "<%=donationContractAddr%>"

        document.querySelector(".donate").addEventListener("click", async () => {
          let result;
          await ca.init();
          ca.donationToken.load(donationTokenAddr);
          result = await ca.donationToken.approve(donationContractAddr, <%=point%>);
          console.log(result);
          <%--console.log(`approve() Transaction: ${result.transactionHash}`);--%>
          // if (result.status === false) {
          //   let messageContainer = document.getElementById("retry");
          //   messageContainer.textContent = "토큰 전송 승인에 실패하였습니다. 기부 확정을 다시 시도해주세요.";
          // }

          ca.donationContract.load(donationContractAddr);
          result = await ca.donationContract.donate(<%=point%>);
          console.log(result);
          if (result.status === true) {
            let forwardUrl = "successNUpdate.jsp?virtual_account=" + encodeURIComponent("<%=v_a%>");
            window.location.href = forwardUrl;
          }
          // else {
          //   let messageContainer = document.getElementById("retry");
          //   messageContainer.textContent = "토큰 전송에 실패하였습니다. 기부 확정을 다시 시도해주세요.";
          // }
          <%--console.log(`donate() Transaction: ${result.transactionHash}`);--%>


<%--          <jsp:forward page="successNUpdate.jsp">--%>
<%--          <jsp:param name="virtual_account" value="<%=v_a%>" ></jsp:param>--%>
<%--          </jsp:forward>;--%>
        });
      });
    </script>
    <style>
      .container {
        text-align: center;
      }

      .donate {
        padding: 10px 20px;
        font-size: 16px;
        background: linear-gradient(to bottom, #3432ba, #2421db); /* 그라데이션 배경 */
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
        <button class="donate" style="">기부확정하기</button>
      </div>
  <div id="retry"></div>
  </body>
</html>
