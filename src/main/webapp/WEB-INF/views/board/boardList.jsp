<%@page import="java.util.List"%>
<%@page import="com.otlb.semi.bulletin.model.vo.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/common/header.jsp"%>
<%@ include file="/WEB-INF/views/common/navbar.jsp"%>

<!-- Custom styles for this template -->
<link
	href="<%=request.getContextPath()%>/resources/css/sb-admin-2.min.css"
	rel="stylesheet">

<!-- Custom styles for this page -->
<link
	href="<%=request.getContextPath()%>/resources/vendor/datatables/dataTables.bootstrap4.min.css"
	rel="stylesheet">

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800">자유게시판</h1>
	<div>
                    	<%-- <button class="btn btn-primary btn-icon-split" 
                    			onclick="location.href='<%= request.getContextPath() %>/board/boardForm'">글쓰기
                		<i class="fa fa-pencil"></i>
                		</button>
                    </div> --%>
	<a class="btn btn-light btn-icon-split"
		href="<%=request.getContextPath()%>/board/boardForm">
		<span>
		<i class="fas fa-envelope fa-fw"></i>글쓰기</span>
	</a>	

	<%-- <i class="fa fa-pencil">
                    <input type="button" value="글쓰기" onclick="location.href='<%= request.getContextPath() %>/board/boardForm'"
                    		class="btn btn-primary btn-icon-split" /></i> --%>
	<p class="mb-4">자유게시판 입니다.</p>

	<!-- DataTales Example -->
	<%-- <div class="card shadow mb-4">
		<div class="card-header py-3">
			<h2 class="m-0 font-weight-bold text-primary">자유게시판</h2>
			<a class="btn btn-light btn-icon-split"
				href="<%=request.getContextPath()%>/board/boardForm"> <span>
					<i class="fas fa-envelope fa-fw"></i>글쓰기
			</span>
			</a>
		</div> --%>
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable" width="100%"
					cellspacing="0">
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>추천수</th>
							<th>작성일</th>
							<th>조회</th>
						</tr>
					</thead>
					<tbody>
					<%
					List<Board> list = (List<Board>) request.getAttribute("list");
					for (Board board : list) {
					%>
						<tr>
							<td><%= board.getNo()%></td>
							<td><a
								href="<%= request.getContextPath()%>/board/boardView?no=<%=board.getNo()%>"><span>[<%=board.getCategory()%>]</span><%=board.getTitle()%>
							</a> 
							<% if (board.getAttachCount() > 0) { %> 
							 <span><i class="fa fa-paperclip"></i></span> 
							<% } %>
							 </td>

							<%-- <%= board.getCommentCount() > 0 ? "(" + board.getCommentCount() + ")" : "" %> --%>
							<%-- <td><%= board.getEmpName()%></td> --%>
							<td><%= board.getLikeCount()%></td>
							<td><%= board.getRegDate()%></td>
							<td><%= board.getReadCount()%></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- </div>
</div>
</div> -->


<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top"> <i
	class="fas fa-angle-up"></i>
</a>

<!-- Logout Modal-->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
	aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
				<button class="close" type="button" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body">Select "Logout" below if you are ready
				to end your current session.</div>
			<div class="modal-footer">
				<button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
				<a class="btn btn-primary" href="login.html">Logout</a>
			</div>
		</div>
	</div>
</div>


<!-- Bootstrap core JavaScript-->
<script
	src="<%=request.getContextPath()%>/resources/vendor/jquery/jquery.min.js"></script>
<script
	src="<%=request.getContextPath()%>/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script
	src="<%=request.getContextPath()%>/resources/vendor/jquery-easing/jquery.easing.min.js"></script>

<!-- Custom scripts for all pages-->
<script
	src="<%=request.getContextPath()%>/resources/js/sb-admin-2.min.js"></script>

<!-- Page level plugins -->
<script
	src="<%=request.getContextPath()%>/resources/vendor/datatables/jquery.dataTables.min.js"></script>
<script
	src="<%=request.getContextPath()%>/resources/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<!-- Page level custom scripts -->
<script
	src="<%=request.getContextPath()%>/resources/js/demo/datatables-demo.js"></script>

</body>

</html>
