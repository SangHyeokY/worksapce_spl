CREATE TABLE MEMBER_TEST (
	MEMBER_ID VARCHAR(20) PRIMARY KEY
	, MEMBER_NAME VARCHAR(20) NOT NULL
	, MEMBER_TEL VARCHAR(20) NOT NULL
	, MEMBER_PW VARCHAR(20) NOT NULL
);

INSERT INTO member_test VALUES ('java', '김자바', '010-7777-3333', '1234');

-- ------------------------------------------------------------------------------------

CREATE TABLE THEATER_TEST (
	THEATER_NUM INT AUTO_INCREMENT PRIMARY KEY
	, THEATER_NAME VARCHAR(30) NOT NULL
	, SEAT_EA INT NOT NULL
); 

ALTER TABLE theater_test ADD SEAT_NUM INT REFERENCES SEAT_TEST (SEAT_NUM);

INSERT INTO theater_test VALUES (1, '자바극장', 1, 1);

-- ------------------------------------------------------------------------------------

CREATE TABLE SEAT_TEST (
	SEAT_NUM INT AUTO_INCREMENT PRIMARY KEY
	, SEAT_ROW INT NOT NULL
	, SEAT_COLUMN INT NOT NULL
	, IS_SEAT VARCHAR(10) DEFAULT 'N'
	, THEATER_NUM INT REFERENCES THEATER_TEST (THEATER_NUM)
);

INSERT INTO seat_test VALUES (1, 50, 50, 'N', 1);

-- ------------------------------------------------------------------------------------

CREATE TABLE RESERVATION_TEST (
	RESERVE_NUM INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_ID VARCHAR(20) REFERENCES member_test (MEMBER_ID)
	, THEATER_NUM INT REFERENCES THEATER_TEST (THEATER_NUM)
	, SEAT_NUM INT REFERENCES SEAT_TEST (SEAT_NUM)
);



-- ------------------------------------------------------------------------------------

-- 5)

SELECT RESERVE_NUM
		, THEATER_NUM
		, SEAT_NUM
FROM reservation_test
WHERE MEMBER_ID = 'java';


-- 6)

SELECT SEAT.SEAT_NUM
		, SEAT_EA
		, (SELECT theater_test.THEATER_NAME
			FROM theater_test 
			WHERE theater_test.THEATER_NUM = seat_test.THEATER_NUM) THEATER_NAME
		, CASE WHEN (SEAT_ROW * SEAT_COLUMN) = SEAT_EA THEN '예매할 수 있는 좌석이 없습니다.'
			ELSE '예매가능'
			END AS '조회결과'
FROM seat_test SEAT
INNER JOIN theater_test THEATER
ON SEAT.SEAT_NUM = THEATER.SEAT_NUM
WHERE THEATER_NUM = (SELECT THEATER_NUM
							FROM theater_test
							WHERE THEATER_NAME = 'VIP');


SELECT THEATER_NAME
		, (SEAT_ROW * SEAT_COLUMN) '예매 가능한 좌석수'
		, SEAT_EA AS '전체 좌석수'
		, CASE WHEN (SEAT_ROW * SEAT_COLUMN) >= SEAT_EA THEN '예매할 수 있는 좌석이 없습니다.'
			ELSE '예매가능'
			END AS '조회결과'
FROM seat_test SEAT
INNER JOIN theater_test THEATER
ON SEAT.SEAT_NUM = THEATER.SEAT_NUM
WHERE SEAT.THEATER_NUM = (SELECT THEATER_NUM
							FROM theater_test
							WHERE THEATER_NAME = 'VIP');
