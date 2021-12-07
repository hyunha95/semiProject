package com.otlb.semi.bulletin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.otlb.semi.bulletin.model.service.BulletinService;
import com.otlb.semi.bulletin.model.vo.Board;
import com.otlb.semi.common.DateFormatUtils;
import com.otlb.semi.common.LineFormatUtils;
import com.otlb.semi.message.model.service.MessageService;

/**
 * Servlet implementation class BoardViewServlet
 */
@WebServlet("/board/boardView")
public class BoardViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BulletinService blletinService = new BulletinService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int no = Integer.valueOf(request.getParameter("no"));
		
		//게시판 데이터 가져오기
		Board board = blletinService.selectOneBoard(no);
		System.out.println(board);
		String regDate = DateFormatUtils.formatDate(board.getRegDate());
		String content = LineFormatUtils.formatLine(board.getContent());
		
		//게시판 댓글 가져오기
		
		
		request.setAttribute("board", board);
		request.setAttribute("regDate", regDate);
		request.setAttribute("content", content);

		request
			.getRequestDispatcher("/WEB-INF/views/board/boardView.jsp")
			.forward(request, response);
	}

}