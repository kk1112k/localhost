package com.icia.web.model;

import java.io.Serializable;

public class Board implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long bbsSeq;		//게시물번호
	private String userId;		//게시자 아이디	
	private String bbsName;		//게시자명
	private String bbsEMail;	//게시자 이메일
	private String bbsPwd;		//게시자 비밀번호
	private String bbsTitle;	//게시자 제목
	private String bbsContent;	//게시자 내용
	private int bbsReadCnt;		//게시자 조회수
	private String regDate;		//게시자 등록일
	
	
	private long startRow;		//시작 rownum
	private long endRow;		//끝 rownum
	
	public Board()
	{
		bbsSeq = 0;		//게시물번호
		userId = "" ;		//게시자 아이디	
		bbsName = "";		//게시자명
		bbsEMail = "";	//게시자 이메일
		bbsPwd = "";		//게시자 비밀번호
		bbsTitle = "";	//게시자 제목
		bbsContent = "";	//게시자 내용
		bbsReadCnt = 0;		//게시자 조회수
		regDate = "";		//게시자 등록일
		
		
		startRow= 0;		//시작 rownum
		endRow= 0;		//끝 rownum
	}

	public long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBbsName() {
		return bbsName;
	}

	public void setBbsName(String bbsName) {
		this.bbsName = bbsName;
	}

	public String getBbsEMail() {
		return bbsEMail;
	}

	public void setBbsEMail(String bbsEMail) {
		this.bbsEMail = bbsEMail;
	}

	public String getBbsPwd() {
		return bbsPwd;
	}

	public void setBbsPwd(String bbsPwd) {
		this.bbsPwd = bbsPwd;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getBbsContent() {
		return bbsContent;
	}

	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public int getBbsReadCnt() {
		return bbsReadCnt;
	}

	public void setBbsReadCnt(int bbsReadCnt) {
		this.bbsReadCnt = bbsReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
	
	
}
