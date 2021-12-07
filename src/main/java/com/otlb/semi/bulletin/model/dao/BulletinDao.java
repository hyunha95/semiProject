package com.otlb.semi.bulletin.model.dao;

import static com.otlb.semi.common.JdbcTemplate.*;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.otlb.semi.bulletin.model.exception.BulletinException;
import com.otlb.semi.bulletin.model.vo.Attachment;
import com.otlb.semi.bulletin.model.vo.Board;
import com.otlb.semi.bulletin.model.vo.BoardComment;
import com.otlb.semi.bulletin.model.vo.Notice;
import com.otlb.semi.emp.model.vo.Emp;

public class BulletinDao {

	private Properties prop = new Properties();
	
	public BulletinDao() {
		String filepath = BulletinDao.class.getResource("/bulletin-query.properties").getPath();
		try {
			prop.load(new FileReader(filepath));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public int insertBoard(Connection conn, Board board) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertBoard");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getCategory());
			pstmt.setString(2, board.getTitle());
			pstmt.setString(3, board.getContent());
			pstmt.setInt(4, board.getEmpNo());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new BulletinException("게시글 등록 실패", e);
		} finally {
			close(pstmt);
		}
		
		return result;
	}

	public int deleteBoard(Connection conn, int no) {
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("deleteBoard");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,  no);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		return result;
	}
	
	
	public int selectLastBoardNo(Connection conn) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectLastBoardNo");
		ResultSet rset = null;
		int boardNo = 0;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			if(rset.next())
				boardNo = rset.getInt(1);
		} catch (SQLException e) {
			throw new BulletinException("최근 게시글 번호 조회 오류", e);
		} finally {
			close(rset);
			close(pstmt);
		}
		return boardNo;
	}

	public int insertAttachment(Connection conn, Attachment attach) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertAttachment");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, attach.getOriginalFilename());
			pstmt.setString(2, attach.getRenamedFilename());
			pstmt.setInt(3, attach.getBoardNo());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new BulletinException("첨부파일 등록 오류", e);
		} finally {
			close(pstmt);
		}
		
		return result;
	}

	public List<Board> selectAllBoard(Connection conn, Map<String, Integer> param) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectAllBoard");
		ResultSet rset = null;
		List<Board> list = new ArrayList();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, param.get("start"));
			pstmt.setInt(2, param.get("end"));
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Board board = new Board();
				
				board.setNo(rset.getInt("no"));
				board.setCategory(rset.getString("category"));
				board.setTitle(rset.getString("title"));
				
				Emp emp = new Emp();
				emp.setEmpName(rset.getString("emp_name"));
				board.setEmp(emp);
//				board.setEmpName(rset.getString("emp_name"));
				board.setContent(rset.getString("content"));
				board.setRegDate(rset.getTimestamp("reg_date"));
				board.setLikeCount(rset.getInt("like_count"));
				board.setReadCount(rset.getInt("read_count"));
				
//				board.setCommentCount(rset.getInt("comment_count"));
				board.setAttachCount(rset.getInt("attach_count"));
				
				list.add(board);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
		}
		return list;
	}

	public List<Attachment> selectAttachmentByBoardNo(Connection conn, int no) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		String sql = prop.getProperty("selectAttachmentByBoardNo");
		List<Attachment> attachments = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			
			rset = pstmt.executeQuery();
			while(rset.next()) {
				Attachment attach = new Attachment();
				attach.setNo(rset.getInt("no"));
				attach.setOriginalFilename(rset.getString("original_filename"));
				attach.setRenamedFilename(rset.getString("renamed_filename"));
				attach.setRegDate(rset.getDate("reg_date"));
				attach.setBoardNo(rset.getInt("board_no"));
				attachments.add(attach);
			}
		} catch (SQLException e) {
			throw new BulletinException("첨부파일 조회 오류", e);
		} finally {
			close(rset);
			close(pstmt);
		}
		return attachments;
	}

	public int updateBoard(Connection conn, Board board) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("updateBoard");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getCategory());
			pstmt.setString(2, board.getTitle());
			pstmt.setString(3, board.getContent());
			pstmt.setInt(4, board.getNo());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new BulletinException("게시판 수정 오류", e);
		} finally {
			close(pstmt);
		}
		return result;
	}

	public int selectTotalBoardCount(Connection conn) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectTotalBoardCount");
		ResultSet rset = null;
		int totalCount = 0;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			if(rset.next()) {
				totalCount = rset.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
		}
		return totalCount;

	}

	public int deleteAttachment(Connection conn, int delFileNo) {
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("deleteAttachment");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, delFileNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new BulletinException("첨부파일 삭제 오류", e);
		} finally {
			close(pstmt);
		}
		
		return result;
	}

	public Attachment selectOneAttachment(Connection conn, int no) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectOneAttachment");
		ResultSet rset = null;
		Attachment attach = null;
		
		try{
			//미완성쿼리문을 가지고 객체생성.
			pstmt = conn.prepareStatement(sql);
			//쿼리문미완성
			pstmt.setInt(1, no);
			//쿼리문실행
			//완성된 쿼리를 가지고 있는 pstmt실행(파라미터 없음)
			rset = pstmt.executeQuery();
			
			if(rset.next()){
				attach = new Attachment();
				attach.setNo(rset.getInt("no"));
				attach.setBoardNo(rset.getInt("board_no"));
				attach.setOriginalFilename(rset.getString("original_filename"));
				attach.setRenamedFilename(rset.getString("renamed_filename"));
				attach.setRegDate(rset.getDate("reg_date"));
			}
		}catch(Exception e){
			throw new BulletinException("첨부파일 조회 오류!", e);
		}finally{
			close(rset);
			close(pstmt);
		}
		return attach;
	}

	
	public Board selectOneBoard(Connection conn, int no) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String sql = prop.getProperty("selectOneBoard");
        Board board = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
			pstmt.setInt(2, no);

            rset = pstmt.executeQuery();
            while(rset.next()) {
                board = new Board();
                board.setNo(rset.getInt("no"));
                board.setTitle(rset.getString("title"));
                board.setContent(rset.getString("content"));
                board.setRegDate(rset.getTimestamp("reg_date"));
                board.setReadCount(rset.getInt("read_count"));
                board.setLikeCount(rset.getInt("like_count"));
                board.setReportYn(rset.getString("report_yn"));
                board.setEmpNo(rset.getInt("emp_no"));
                board.setCategory(rset.getString("category"));
                board.setDeleteYn(rset.getString("delete_yn"));
                board.setCommentCount(rset.getInt("count"));
                
                Emp emp = new Emp();
                emp.setEmpName(rset.getString("emp_name"));
                emp.setDeptName(rset.getString("dept_name"));
                board.setEmp(emp);
            }
        } catch (SQLException e) {
            throw new BulletinException("게시판 조회 오류", e);
        } finally {
            close(rset);
            close(pstmt);
        }
        return board;
    }


	public List<Notice> selectAllNotice(Connection conn) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectAllNotice");
		ResultSet rset = null;
		List<Notice> list = new ArrayList();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Notice notice = new Notice();
				
				notice.setNo(rset.getInt("no"));
				notice.setTitle(rset.getString("title"));
				notice.setContent(rset.getString("content"));
				Emp emp = new Emp();
				emp.setEmpName(rset.getString("emp_name"));
				notice.setEmp(emp);
				notice.setRegDate(rset.getTimestamp("reg_date"));
				notice.setReadCount(rset.getInt("read_count"));
				
//				board.setCommentCount(rset.getInt("comment_count"));
//				notice.setAttachCount(rset.getInt("attach_count"));
				list.add(notice);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
		}
		return list;
	}

	public List<BoardComment> selectBoardCommentList(Connection conn, int no) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectBoardCommentList");
		ResultSet rset = null;
		List<BoardComment> boardCommentList = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()){
				BoardComment bc = new BoardComment();
				bc.setNo(rset.getInt("no"));
				bc.setCommentLevel(rset.getInt("comment_level"));
				bc.setContent(rset.getString("content"));
				bc.setReportYn(rset.getString("report_yn"));
				bc.setCommentRef(rset.getInt("comment_ref"));
				bc.setRegDate(rset.getTimestamp("reg_date"));
				bc.setBoardNo(rset.getInt("board_no"));
				bc.setEmpNo(rset.getInt("emp_no"));
				bc.setDeleteYn(rset.getString("delete_yn"));
				
				
				Emp emp = new Emp();
				emp.setEmpName(rset.getString("emp_name"));
				emp.setDeptName(rset.getString("dept_name"));
				
				bc.setEmp(emp);
				
				boardCommentList.add(bc);
			}
		} catch (SQLException e) {
			throw new BulletinException("게시판 댓글 조회 오류", e);
		} finally {
			close(rset);
			close(pstmt);
		}
		
		return boardCommentList;
	}

	public int updateReadCount(Connection conn, int no) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("updateReadCount");
		int result = 0;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public List<Board> selectAllAnonymousBoard(Connection conn) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("selectAllAnonymousBoard");
		ResultSet rset = null;
		List<Board> list = new ArrayList();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Board board = new Board();
				
				board.setNo(rset.getInt("no"));
				board.setTitle(rset.getString("title"));
				board.setContent(rset.getString("content"));
//				Emp emp = new Emp();
//				emp.setEmpName(rset.getString("emp_name"));
//				board.setEmp(emp);
				board.setCategory(rset.getString("category"));
				board.setRegDate(rset.getTimestamp("reg_date"));
				board.setReadCount(rset.getInt("read_count"));
				
//				board.setCommentCount(rset.getInt("comment_count"));
				board.setAttachCount(rset.getInt("attach_count"));
				list.add(board);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
		}
		return list;
	}

	public List<Board> searchBoard(Connection conn, Map<String, Object> param) {
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("searchBoard");
		ResultSet rset = null;
		List<Board> list = new ArrayList<>();
		
		String searchType = (String) param.get("searchType");
		String searchKeyword = (String) param.get("searchKeyword");
		switch(searchType) {
		case "title": sql += " title like '%" + searchKeyword + "%'"; break;
		case "writer": sql += " writer like '%" + searchKeyword + "%'"; break;
		case "category": sql += " category '%" + searchKeyword + "%'"; break;
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			while(rset.next()) {
				Board board = new Board();
				board.setNo(rset.getInt("no"));
				board.setCategory(rset.getString("category"));
				board.setTitle(rset.getString("title"));
				
				Emp emp = new Emp();
				emp.setEmpName(rset.getString("emp_name"));
				board.setEmp(emp);
//				board.setEmpName(rset.getString("emp_name"));
				board.setContent(rset.getString("content"));
				board.setRegDate(rset.getTimestamp("reg_date"));
				board.setLikeCount(rset.getInt("like_count"));
				board.setReadCount(rset.getInt("read_count"));
				
//				board.setCommentCount(rset.getInt("comment_count"));
				board.setAttachCount(rset.getInt("attach_count"));
				
				list.add(board);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
		}
		return list;
	}
	

	
}

















