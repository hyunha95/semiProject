<%@page import="com.otlb.semi.message.model.vo.Message"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="/WEB-INF/views/common/header.jsp"%>
<!-- 받은 쪽지함 jsp -->
<body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- 쪽지합 nav -->
		<%@ include file="/WEB-INF/views/message/common/messageNav.jsp"%>
		
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
        	<div class="container">
        		<button class="btn btn-primary btn-icon-split" onclick="delMessage();">삭제</button>
			</div>
		 	<hr class="sidebar-divider my-3">
            <!-- Main Content -->
            <div id="content">
	 		<div class="row">
	 			<div class="col-sm-12">
	 				<table class="table table-bordered dataTable">
	 					<thead>
                           <tr>
                               <th><input type="checkbox" class="checkAll"/></th>
                               <th>보낸사람</th>
                               <th>내용</th>
                               <th>날짜</th>
                           </tr>
                         </thead>
                         <tbody>
<%
/* 
	로그인 회원이 받은 쪽지데이터 출력
*/
List<Message> list = (List<Message>) request.getAttribute("list");
List<String> sentDateList = (List<String>) request.getAttribute("sentDateList");
	//for(Message message : list){
	for(int i = 0; i < list.size(); i++){	
		Message message = list.get(i);
%>
                         	<tr>
                         		<td><input type="checkbox" name="check" value="<%= message.getNo()%>"/></td>
                         		<td <%= message.getReadDate() == null ? "style=\"color: #4e73df;\"" : "" %>>
                         			<%= message.getEmp().getEmpName() %>
                         		</td>
                         		<td>
                         			<a 
                       				href="<%= request.getContextPath() %>/message/messageView?no=<%= message.getNo()%>" 

									<%= message.getReadDate() != null ? "style=\"color: #858796;\"" : "" %>>
                       				<%= message.getContent() %>
                       				</a>
                   				</td>
                         		<%-- <td><%= message.getSentDate() %></td> --%>
                         		<td><%= sentDateList.get(i) %></td>
                         	</tr>
<% 
	}
 %>
                         </tbody>
 					</table>
	 			</div>
	 		<form
	 		
	 			id = "delFrm"
				name="messageDelFrm"
				method="POST" 
				action="<%= request.getContextPath() %>/message/receivedMessageDelete" >
				<input type="hidden" id="no" name="no" value="" />
			</form>	
	 		</div>
                <!-- Begin Page Content -->
                <div class="container-fluid">

                    

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->
<script>
//메세지 삭제 제어
function delMessage(){
	// 선택된 갯수 
	var count = $("input:checkbox[name=check]:checked").length;  

	//선택한 쪽지가 1개 이상일때
	if(count > 0){
		if(confirm("삭제하시겠습니까?")){
			
			//check박스 요소들 변수 저장
			var check = document.getElementsByName("check");
			//글번호 저장
			var no = "";
			//check박스 전체순회
			for(let i = 0; i < check.length; i++){
				//해당순번의 체크박스가 체크되어 있으면
				if(check[i].checked){
					//,를 구분자로 값을 연결
					no += check[i].value + ",";
				}
			}
			var inputNo = document.getElementById("no");
			//input value에 글번호 대입
			inputNo.value = no;
			console.log("input value: " + inputNo.value);
			$("form[name=messageDelFrm]").submit();	
			//$(document.messageDelFrm).submit();
			
		}
	//선택한 쪽지가 0개일때
	}else{
		alert("선택한 쪽지가 없습니다.");
	}
}

// 체크박스 제어
$(".checkAll").click(function() {
	if($(".checkAll").is(":checked")) $("input[name=check]").prop("checked", true);
	else $("input[name=check]").prop("checked", false);
});

$("input[name=check]").click(function() {
	var total = $("input[name=check]").length;
	var checked = $("input[name=check]:checked").length;
	
	if(total != checked) $(".checkAll").prop("checked", false);
	else $(".checkAll").prop("checked", true); 
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp"%>