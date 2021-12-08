<%@page import="com.otlb.semi.emp.model.service.EmpService"%>
<%@page import="com.otlb.semi.bulletin.model.vo.BoardComment"%>
<%@page import="java.util.List"%>
<%@page import="com.otlb.semi.bulletin.model.vo.Board"%>
<%@page import="com.otlb.semi.bulletin.model.vo.Attachment"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<body id="page-top">

<%@ include file="/WEB-INF/views/common/navbar.jsp"%>
<%
	Board board  = (Board) request.getAttribute("board");
	String regDate = (String) request.getAttribute("regDate");
	String content = (String) request.getAttribute("content");	
	
	String writerProfileImagePath = "/img/profile/profile.png";
	Boolean writerProfileImageExists = (boolean) ((request.getAttribute("writerProfileImageExists") == null) ? false : request.getAttribute("writerProfileImageExists"));
	if(writerProfileImageExists) writerProfileImagePath = "/img/profile/" + board.getEmpNo() + ".png";

%>

 		<!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
	        <div class="container-fluid">
		    	<button class="btn btn-primary btn-icon-split" onclick="moveBoardList();">목록</button>
				<hr class="sidebar-divider my-3">
			</div>
			 <div class="container-fluid" id="titleContent">
			 	<p>자유게시판</p>
		 		<h5 style="font-weight: bold;">[<%= board.getCategory() %>] <%= board.getTitle() %></h5>
		 		<img class="img-profile rounded-circle" src="<%= request.getContextPath() + writerProfileImagePath %>" height="40px" />
			 	<span class="empPopover" data-toggle="popover" ><%= board.getEmp().getEmpName() %>(<%= board.getEmp().getDeptName() %>)</span>
			 	
			 	<span>추천수<%= board.getLikeCount() %></span>
			 	<span>조회<%= board.getReadCount() %></span>
			 	<span><%= regDate %></span>
<%
 	List<Attachment> attachments = board.getAttachments();
    if(attachments != null && !attachments.isEmpty()){	
    	if (attachments != null && !attachments.isEmpty()) {
    		for(int i = 0; i < attachments.size(); i++){
    			Attachment attach = attachments.get(i);
%>	
			 	<img src="<%=request.getContextPath() %>/img/profile/file.png" width=16px alt="첨부파일" />
			 	<a href="<%= request.getContextPath() %>/board/boardView%></a>
<%	
    		}
	}
%>			 	
			 	
			 </div>
			 <br />
			 
			 <div class="container-fluid" id="Content" style="margin: 10px">
			 	<span><%= content %></span>
			 </div>
			  <div class="container-fluid" id="commentContent">
			 	<span>댓글 <%= board.getCommentCount() %></span>
			 	<button class="btn btn-primary btn-icon-split" id="recommend-btn" onclick="recommend();">추천하기</button>
			 	<hr class="sidebar-divider my-3">
<% 
	List<BoardComment> commentList = (List<BoardComment>) request.getAttribute("boardCommentList");
	List<String> commentListContent = (List<String>) request.getAttribute("commentListContent");
	List<String> commentListDate = (List<String>) request.getAttribute("commentListDate");
	
	List<Boolean> commenterImageList = (List<Boolean>) request.getAttribute("commenterImageList");
	
	if(commentList != null && !commentList.isEmpty()){
%>
				<table>
<%
		for(int i = 0; i < commentList.size(); i++){
		//for(BoardComment bc : commentList){
			BoardComment bc = commentList.get(i);
			String commentDate = commentListDate.get(i);
			String commentContent = commentListContent.get(i);
			
			String commenterProfileImagePath = "/img/profile/profile.png";
			Boolean commenterProfileImageExists = commenterImageList.get(i);
			
//			Boolean commenterProfileImageExists = (boolean) ((request.getAttribute("commenterProfileImageExists") == null) ? false : request.getAttribute("commenterProfileImageExists"));
			if(commenterProfileImageExists) commenterProfileImagePath = "/img/profile/" + bc.getEmpNo() + ".png";
			boolean removable = (
					  loginEmp.getEmpNo() == bc.getEmpNo()
					  || EmpService.ADMIN_ROLE.equals(loginEmp.getEmpRole()));
			if(bc.getCommentLevel() == 1){
				//댓글을 삭제했다면
				if(bc.getDeleteYn().equals("N")){
			
%>				
					<tr class="level1">
						<td style="padding: 15px;">
							<img class="img-profile rounded-circle" src="<%= request.getContextPath() + commenterProfileImagePath %>" height="30px" />
							<sub class="comment-writer empPopover" data-toggle="popover" style="font-weight: bold;"><%= bc.getEmp().getEmpName() %>(<%= bc.getEmp().getDeptName() %>)</sub>
							<sub class="comment-date"><%= commentDate %></sub>
							<br />
							<!-- 댓글내용 -->
							<%= commentContent %>
						</td>
						<td>
							<button class="btn btn-primary btn-icon-split" id="btn-reply" value="<%= bc.getNo()%>" onclick="commentReply(this);">답글</button>
<%
					if(removable){
%>						
							<button class="btn btn-primary btn-icon-split" name="btn-delete" value="<%= bc.getNo()%>">삭제</button>
<%
					}
%>					
						</td>
					</tr>
<%			

				}else{					
%>
					<tr class="level1" style="color: #4e73df;">
						<td style="padding: 15px;">
							<!-- 댓글내용 -->
							삭제된 댓글입니다.
						</td>
	
<%
				}
%>					
					</tr>
<%
			} else{
				if(bc.getDeleteYn().equals("N")){
			
%>
					<tr class="level2">
						<td style="padding-left: 50px; padding-bottom: 15px;">
							<img class="img-profile rounded-circle" src="<%= request.getContextPath() + commenterProfileImagePath %>" height="30px" />
							<sub class="comment-writer empPopover" data-toggle="popover" style="font-weight: bold;"><%= bc.getEmp().getEmpName() %>(<%= bc.getEmp().getDeptName() %>)</sub>
							<sub class="comment-date"><%= commentDate %></sub>
							<br />
							<!-- 대댓글내용 -->
							<%= commentContent %>
						</td>
						<td>
							<button class="btn btn-primary btn-icon-split" id="btn-reply" value="<%= bc.getNo()%>" onclick="commentReply(this);">답글</button>
<%
					if(removable){
%>	
							<button class="btn btn-primary btn-icon-split" name="btn-delete" value="<%= bc.getNo()%>">삭제</button>
<%
					}
%>					
						</td>	
					</tr>
<%

				} else{
%>						
					<tr class="level2" style="color: #4e73df;">
						<td style="padding-left: 50px; padding-bottom: 15px;">
							<!-- 대댓글내용 -->
							삭제된 댓글입니다.
						</td>
					</tr>

<% 
				}
			}
%>
			
<%
		}
%>
				</table>
<%

		
	}
%>

				<hr class="sidebar-divider my-3">
				<!-- 댓글입력칸 -->
				<form 
					action="<%=request.getContextPath()%>/board/boardCommentEnroll" 
					method="post"
					name="boardCommentFrm">
				    <input type="hidden" name="no" value="<%= board.getNo() %>" />
				    <input type="hidden" name="commentLevel" value="1" />
				    <input type="hidden" name="commentRef" value="0" />    
				    <div id="comment-input">
						<textarea name="content" cols="100" rows="3" style="resize: none;" placeholder="인터넷은 우리가 함께 만들어가는 소중한 공간입니다. 글 작성 시 타인에 대한 배려와 책임을 담아주세요."></textarea>
					   	<div class="counter" style="float: right;">
								<span id="count">0</span><span>/100</span>
                   		</div>
					   	<br />
					    <button type="submit" class="btn btn-primary btn-icon-split" >등록</button>
					</div>
				</form>
			 </div>
			 

			 <form
				name=recommendFrm
				method="POST" 
				action="<%= request.getContextPath() %>/board/boardLikeCount" >
				<input type="hidden" name="no" value="<%= board.getNo() %>" />
			</form>	
			<form 
				action="<%= request.getContextPath() %>/board/boardCommentDelete" 
				name="boardCommentDelFrm"
				method="POST">
				<input type="hidden" name="no" />
				<input type="hidden" name="boardNo" value="<%= board.getNo() %>"/>
			</form>

<script src="<%= request.getContextPath() %>/js/empPopup.js"></script>
<script>
	setPopover("<%= request.getContextPath() %>", "게시글보기 링크", "/emp/empInfoView?empNo=<%= board.getEmpNo() %>", "대화 링크", "/message/messageForm?senderNo=");
</script>
<script>
//추천하기 버튼
function recommend(){
	$("form[name=recommendFrm]").submit();	
}

/* 댓글 쓰기 100자 제한 코드 */
$('textarea[name=content]').on('keyup', function() {
	//console.log($(this).val().length);
	
	$('#count').html($(this).val().length);
	
	if($(this).val().length > 100) {
		alert("100자까지만 입력할 수 있습니다.");
           $(this).val($(this).val().substring(0, 500));
           $('#count').html("100");
       }
});


//댓글등록전 검사
$(document.boardCommentFrm).submit((e) => {

	const $content = $("[name=content]", e.target);
	if(!/^(.|\n)+$/.test($content.val())){
		alert("댓글을 작성해주세요.");
		e.preventDefault();
	}
});
//댓글 삭제 기능
$("button[name=btn-delete]").click(function(){
	console.log(12345);

	if(confirm("해당 댓글을 삭제하시겠습니까?")){
		var $frm = $(document.boardCommentDelFrm);
		var no = $(this).val();
		console.log(no);
		$frm.find("[name=no]").val(no);
		$frm.submit();
	}
});	
//대댓글 기능
function commentReply(e) {
	//대댓글 상위댓글 저장
	const commentRef = e.value;
	const tr = `<tr>
		<td colspan="2" style="text-align:left">
			<form 
				action="<%=request.getContextPath()%>/board/boardCommentEnroll" 
				method="post">
			    <input type="hidden" name="no" value="<%= board.getNo() %>" />
			    <input type="hidden" name="commentLevel" value="2" />
			    <input type="hidden" name="commentRef" value="\${commentRef}" />    
				<textarea name="content" cols="60" rows="3" style="resize: none;"></textarea>
			    <button type="submit" class="btn btn-primary btn-icon-split">등록</button>
			</form>
		</td>`;
	const baseTr = e.parentNode.parentNode;
	const $baseTr = $(e.target).parent().parent();
	const $tr = $(tr);

	$tr.insertAfter(baseTr)	
	.find("form")
	.submit((e) => {
		const $content = $("[name=content]", e.target);
		if(!/^(.|\n)+$/.test($content.val())){
			alert("댓글을 작성해주세요.");
			e.preventDefault();
		}
	});

	//$(e.target).off("click");
		
}

//게시판 리스트로 돌아가는 함수
function moveBoardList() {
	location.href = "<%=request.getContextPath()/board/boardList %>";
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp"%>