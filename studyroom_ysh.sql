-- 요금제 
CREATE TABLE STUDYROOM_CHARGE (
	CHARGE_CODE INT AUTO_INCREMENT PRIMARY KEY
	, CHARGE_NAME VARCHAR(10) NOT NULL
	, CHARGE_FEE INT NOT NULL	approval
);

ALTER TABLE STUDYROOM_CHARGE ADD CHARGE_DATE INT NOT NULL AFTER CHARGE_FEE;

ALTER TABLE studyroom_charge CHANGE CHARGE_NAME CHARGE_NAME VARCHAR(50) NOT NULL;

INSERT INTO STUDYROOM_CHARGE VALUES(1, '30일', 220000, 30);
INSERT INTO STUDYROOM_CHARGE VALUES(2, '21일', 180000, 21);
INSERT INTO STUDYROOM_CHARGE VALUES(3, '14일', 130000, 14);
INSERT INTO STUDYROOM_CHARGE VALUES(4, '7일', 70000, 7);
INSERT INTO STUDYROOM_CHARGE VALUES(5, '1일', 10000, 1);


-- 이용자 메세지 주고받기
CREATE TABLE studyroom_message (
	MESSAGE_CODE INT AUTO_INCREMENT PRIMARY KEY
	, MESSAGE_CONTENT VARCHAR(300) NOT NULL
	, MESSAGE_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, TO_FROM VARCHAR(10) DEFAULT 'TO'
	, MEMBER_CODE INT REFERENCES STUDYROOM_MEMBER (MEMBER_CODE) -- FK
);

ALTER TABLE studyroom_message ADD TO_FROM VARCHAR(10) DEFAULT 'TO' AFTER MESSAGE_DATE;




INSERT INTO STUDYROOM_MESSAGE (
            MESSAGE_CONTENT
        ) VALUES (
            'ㄴㅇㄹ'
        );
SELECT * FROM studyroom_message;studyroom_message

-- 로그 확인하기 view
-- 사용자 이름, 사용자 이용시간(시작, 종료, 사용시간), 결제내역, 좌석번호, 예약정보, 메세지
CREATE OR REPLACE VIEW STUDYROOM_LOG_VIEW AS
SELECT  MEMBER.MEMBER_CODE
		, MEMBER_NAME
		
		, RESERVATION_CODE
		, RESERVATION_DATE
		
		, APPROVAL_CODE
		
		, DAY_INPUT
		, IN_OUT
		
		, SEAT_POWER
		, SEAT_FLOOR
		
		, MESSAGE_CODE
		, MESSAGE_CONTENT
		, MESSAGE_DATE
FROM studyroom_member MEMBER
INNER JOIN studyroom_reservation RESERVE
ON MEMBER.MEMBER_CODE = RESERVE.MEMBER_CODE
INNER JOIN approval APPROVAL
ON MEMBER.MEMBER_CODE = APPROVAL.MEMBER_CODE
INNER JOIN studyroom_inout INPUT
ON MEMBER.MEMBER_CODE = INPUT.MEMBER_CODE
INNER JOIN STUDYROOM_SEAT SEAT
ON MEMBER.MEMBER_CODE = SEAT.MEMBER_CODE
INNER JOIN STUDYROOM_MESSAGE MSG
ON MEMBER.MEMBER_CODE = MSG.MEMBER_CODE;


-- -------------------------------------------------------------------------------------

-- 사용자 정보
CREATE TABLE STUDYROOM_MEMBER (
	MEMBER_CODE INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_ID VARCHAR(15) UNIQUE NOT NULL
	, MEMBER_PW VARCHAR(50) NOT NULL
	, MEMBER_NAME VARCHAR(10) NOT NULL
	, MEMBER_TEL VARCHAR(13) NOT NULL
	, MEMBER_BIRTH DATETIME
	, MEMBER_ADDR VARCHAR(50) NOT NULL
	, MEMBER_DETAIL VARCHAR(50)
	, MEMBER_GENDER VARCHAR(2)
	, IS_ADMIN VARCHAR(10) DEFAULT 'USER'   -- 'USER', 'ADMIN', 'ARBEIT'
);

-- 우편번호 컬럼 추가  member_birth 다음에
ALTER TABLE studyroom_member ADD COLUMN  POST_CODE VARCHAR(10) AFTER MEMBER_BIRTH;

-- 컬럼명 MEMBER_DETAIL  -> ADDR_DETAIL로
ALTER TABLE studyroom_member CHANGE MEMBER_DETAIL ADDR_DETAIL VARCHAR(50);
SELECT * FROM studyroom_member;



-- 예약 정보 (안씀)
CREATE TABLE STUDYROOM_RESERVATION(
	RESERVATION_CODE INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_CODE INT REFERENCES STUDYROOM_MEMBER (MEMBER_CODE)
	, SEAT_NUM INT REFERENCES STUDYROOM_SEAT (SEAT_NUM)
	, RESERVATION_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, CHARGE_CODE INT REFERENCES studyroom_charge (CHARGE_CODE)
);


-- 결재(me)
CREATE TABLE APPROVAL(
	APPROVAL_CODE INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_CODE INT REFERENCES STUDYROOM_MEMBER (MEMBER_CODE)
	, CHARGE_CODE INT REFERENCES studyroom_charge (CHARGE_CODE)
	, CARD VARCHAR(5) DEFAULT 'Y'   -- 'Y', 'N'
);

ALTER TABLE approval ADD COLUMN APPROVAL_DATE DATETIME DEFAULT CURRENT_TIMESTAMP AFTER APPROVAL_CODE;
ALTER TABLE APPROVAL ADD COLUMN APPROVAL_FEE INT NOT NULL AFTER APPROVAL_CODE;
ALTER TABLE approval CHANGE CARD COUPON_USE VARCHAR(5) DEFAULT 'N';


-- 입실, 퇴실(me)
CREATE TABLE STUDYROOM_INOUT(
	DAY_INPUT INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_CODE INT REFERENCES STUDYROOM_MEMBER (MEMBER_CODE)
	, IN_OUT VARCHAR(5)
);

ALTER TABLE studyroom_inout ADD COLUMN INOUT_TIME DATETIME DEFAULT CURRENT_TIMESTAMP AFTER IN_OUT;

-- -------------------------------------------------------------------------------------

-- 좌석 상태
CREATE TABLE SEAT_STATUS (
	STATUS_NUM INT AUTO_INCREMENT PRIMARY KEY
	, STATUS_NAME VARCHAR(20) NOT NULL UNIQUE
);
INSERT INTO SEAT_STATUS VALUES(1, '사용중');
INSERT INTO SEAT_STATUS VALUES(2, '사용가능');
INSERT INTO SEAT_STATUS VALUES(3, '수리중');

-- 좌석정보
CREATE TABLE STUDYROOM_SEAT (
	SEAT_NUM INT AUTO_INCREMENT PRIMARY KEY
	, SEAT_POWER VARCHAR(10) DEFAULT 'OFF' -- (ON,OFF)studyroom_seat
	, SEAT_FLOOR INT DEFAULT 1 NOT NULL -- (1 , 2)
	, MEMBER_CODE INT REFERENCES STUDYROOM_MEMBER (MEMBER_CODE)
	, STATUS_NUM INT DEFAULT 2 REFERENCES seat_status (STATUS_NUM)
	, AGE_CODE INT DEFAULT 1 REFERENCES floor_age (AGE_CODE)
);

INSERT INTO studyroom_seat VALUES (1, 'OFF', 1, null, 2, 1);

-- 층(나이별 구분) 정보
CREATE TABLE FLOOR_AGE (
	AGE_CODE INT AUTO_INCREMENT PRIMARY KEY
	, AGE_NAME VARCHAR(15) NOT NULL
);

INSERT INTO FLOOR_AGE VALUES(1, '20세 미만');
INSERT INTO FLOOR_AGE VALUES(2, '20세 이상');

CREATE TABLE COUPON(
	COUPON_CODE INT AUTO_INCREMENT PRIMARY KEY -- 쿠폰 종류의 코드
	, COUPON_NAME VARCHAR(50) NOT NULL
	, DISCOUNT_PERCENT INT NOT NULL -- % 제외한 할인율만 입력
);

CREATE TABLE MEMBER_COUPON(
	OWN_COUPON_CODE INT AUTO_INCREMENT PRIMARY KEY -- 회원에게 나눠진 쿠폰 코드
	, COUPON_CODE INT REFERENCES COUPON (COUPON_CODE) -- 쿠폰 종류 코드
	, MEMBER_CODE INT REFERENCES studyroom_member (MEMBER_CODE)
);

-- -------------------------------------------------------------------------------------

-- 독서실 게시판 테이블 
CREATE TABLE STUDYROOM_BOARD (
	BOARD_CODE INT AUTO_INCREMENT PRIMARY KEY
	, BOARD_TITLE VARCHAR(20) NOT NULL
	, BOARD_WRITER VARCHAR (20) NOT NULL REFERENCES STUDYROOM_MEMBER (MEMBER_ID)
	, BOARD_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, BOARD_CONTENT VARCHAR(200) NOT NULL
	, BOARD_SECRET VARCHAR(10) DEFAULT 'NO' -- YES : 비밀글 , NO : 공개글 
	, READ_CNT INT DEFAULT 0
);

-- 독서실 게시판 댓글 테이블
CREATE TABLE STUDYROOM_COMMENT (
	COMMENT_CODE INT AUTO_INCREMENT PRIMARY KEY
	,	COMMENT_WRITER VARCHAR(20) NOT NULL 
	, 	COMMENT_CONTENT VARCHAR(200) NOT NULL
	,	COMMENT_DATE DATETIME DEFAULT CURRENT_TIMESTAMP 
	, 	BOARD_CODE INT NOT NULL REFERENCES STUDYROOM_BOARD (BOARD_CODE)
);

-- 게시판 이미지 관리 테이블 
CREATE TABLE BOARD_IMG (
	IMG_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ORIGIN_FILE_NAME VARCHAR(100) NOT NULL
	, ATTACHED_FILE_NAME VARCHAR(100) NOT NULL
	, BOARD_CODE INT NOT NULL REFERENCES STUDYROOM_BOARD (BOARD_CODE)
);

ALTER TABLE studyroom_board ADD BOARD_ANSWER VARCHAR(10) DEFAULT 'NO';
ALTER TABLE studyroom_board DROP COLUMN READ_CNT;



-- -------------------------------------------------------------------------------------
