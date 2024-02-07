-- 쇼핑몰 프로젝트 테이블

-- 회원정보 테이블
CREATE TABLE SHOP_MEMBER (
	MEMBER_ID VARCHAR(20) PRIMARY KEY
	, MEMBER_PW VARCHAR(20) NOT NULL
	, MEMBER_NAME VARCHAR(20) NOT NULL
	, GENDER VARCHAR(10) NOT NULL -- 남자 male, 여자 female
	, MEMBER_EMAIL VARCHAR(50) NOT NULL UNIQUE
	, MEMBER_TEL VARCHAR(20) -- 010-1111-2222
	, MEMBER_ADDR VARCHAR(50)
	, ADDR_DETAIL VARCHAR(50)
	, POST_CODE VARCHAR(10) -- 13011
	, JOIN_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, MEMBER_ROLL VARCHAR(20) DEFAULT 'USER'-- 권한 USER, ADMIN
);

-- 상품 카테고리 정보 테이클
CREATE TABLE ITEM_CATEGORY (
	CATE_CODE INT AUTO_INCREMENT PRIMARY KEY
	, CATE_NAME VARCHAR(50) NOT NULL UNIQUE
);

-- 상품 정보 저장
INSERT INTO item_category VALUES (1, 'IT/인터넷');
INSERT INTO item_category VALUES (2, '소설/에세이');
INSERT INTO item_category VALUES (3, '문화/여행');

-- 상품 정보 테이블
CREATE TABLE SHOP_ITEM (
	ITEM_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ITEM_NAME VARCHAR(50) NOT NULL UNIQUE
	, ITEM_PRICE INT NOT NULL
	, ITEM_STOCK INT DEFAULT 10
	, ITEM_INTRO VARCHAR(100)
	, REG_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, CATE_CODE INT NOT NULL REFERENCES item_category (CATE_CODE) 
);

-- 상품의 이미지 정보를 관리하는 테이블
CREATE TABLE ITEM_IMAGE (
	IMG_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ORIGIN_FILE_NAME VARCHAR(100) NOT NULL
	, ATTACHED_FILE_NAME VARCHAR(100) NOT NULL
	, IS_MAIN VARCHAR(2) NOT NULL -- 'Y', 'N'
	, ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
);

-- 다중 등록
INSERT INTO item_image (
	IMG_CODE
	, ORIGIN_FILE_NAME
	, ATTACHED_FILE_NAME
	, IS_MAIN
	, ITEM_CODE
) VALUES 
(1, 'aa.jpg', 'aaa.jpg', 'Y', 1), 
(2, 'bb.jpg', 'bbb.jpg', 'N', 1), 
(3, 'cc.jpg', 'ccc.jpg', 'N', 1);

-- 다음에 들어갈 ITEM_CODE를 조회
-- 현재 등록된 ITEM_CODE 중 가장 큰 값을 구한 후 +1
SELECT IFNULL(MAX(ITEM_CODE), 0) + 1 FROM shop_item;
-- SELECT ITEM_CODEitem_image
-- 	, IFNULL(ITEM_CODE, 0)
-- FROM shop_item;

-- 첨부된 이미지를 같이 표시
SELECT SI.ITEM_CODE
	, ITEM_NAME
	, ITEM_PRICE
	, ATTACHED_FILE_NAME
FROM shop_item SI INNER JOIN item_image II
ON SI.ITEM_CODE = II.ITEM_CODE
WHERE IS_MAIN = 'Y'
ORDER BY REG_DATE DESC;

-- 상품 상세 정보 조회
-- item_code, item_name, item_price, item_intro
-- attached_file_name
SELECT ITEM.ITEM_CODE
		, ITEM_NAME
		, ITEM_PRICE
		, ITEM_INTRO
		, ATTACHED_FILE_NAME
FROM shop_item ITEM INNER JOIN item_image IMG
ON ITEM.ITEM_CODE = IMG.ITEM_CODE
WHERE ITEM.ITEM_CODE = 1;

-- 장바구니 정보 테이블
CREATE TABLE SHOP_CART(
		CART_CODE INT AUTO_INCREMENT PRIMARY KEY
	,	ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
	, 	MEMBER_ID VARCHAR(20) NOT NULL REFERENCES shop_member (MEMBER_ID)
	, 	CART_CNT INT NOT NULL
	,  CART_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
);



-- 쿼리 작동 테스트

SELECT MEMBER_IDshop_item
     , MEMBER_PW
     , MEMBER_NAME
     , MEMBER_ROLL
FROM shop_member;

SELECT ITEM.ITEM_CODE
        , ITEM_NAME
        , ITEM_PRICE
        , ATTACHED_FILE_NAME
        FROM shop_item ITEM INNER JOIN item_image IMG
        ON ITEM.ITEM_CODE = IMG.ITEM_CODE
        WHERE IS_MAIN = 'Y'
        ORDER BY REG_DATE DESC
    
    -- 회원아이디가 'java'인 회원의
    -- 장바구니에 담긴 장바구니 목록을 조회
	 -- 장바구니 코드, 대표이미지명(첨부된 파일명)
	 -- 상품명, 가격, 개수, 총가격
SELECT CART_CODE
 	  , ITEM_NAME 
	  , ITEM_PRICE
     , CART_CNT
	  , ITEM_PRICE * CART_CNT AS TOTAL_PRICE
	

	, MEMBER_ID AS'java'
	, ITEM_NAME 
	, ATTACHED_FILE_NAME
	
FROM shop_cart CART INNER JOIN SHOP_MEMBER MEMBER; 
ON CART.MEMBER_ID = MEMBER.MEMBER_ID;



-- join된 컬럼이 같은 값 하나라도 있으면 됨
FROM shop_cart CART 
INNER JOIN shop_item ITEM
ON CART.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_image IMG
ON CART.ITEM_CODE = IMG.ITEM_CODE
WHERE MEMBER_ID = 'java'
AND IS_MAIN = 'Y'
ORDER BY REG_DATE DESC;

-- 장바구니와 관련된 모든 정보를 조회할 수 있는 VIEW 생성
CREATE OR REPLACE VIEW CART_VIEW
AS
SELECT CART_CODE
	, CART.ITEM_CODE
	, CART.MEMBER_ID
	, CART_CNT
	, CART_DATE
	
	, ITEM_NAME
	, ITEM_PRICE
	, ITEM_INTRO
	, ITEM_PRICE * CART_CNT TOTAL_PRICE
	
	, MEMBER_NAME
	, MEMBER_TEL
   , CONCAT(POST_CODE, ' ',MEMBER_ADDR, ' ',ADDR_DETAIL) ADDRESS
   
   , ATTACHED_FILE_NAME
   , ORIGIN_FILE_NAME
   , IS_MAIN
   , IMG_CODE
   
   , ITEM.CATE_CODE
   , CATE_NAME
FROM shop_cart CART
INNER JOIN shop_item ITEM
ON CART.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN shop_member MEMBER
ON MEMBER.MEMBER_ID = CART.MEMBER_ID
INNER JOIN item_image IMG
ON IMG.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_category CATE
ON CATE.CATE_CODE = ITEM.CATE_CODE
WHERE IS_MAIN = 'Y';


-- 내 장바구니에 지금 추가하려는 상품이 있는지 확인
SELECT *FROM shop_cart;

-- 아이디가 'java'인 회원의 장바구니에 
-- ITEM_CODE가 1인 상품이 존재하는지 확인
SELECT COUNT(CART_CODE)
FROM shop_cart
WHERE MEMBER_ID = 'admin'
AND ITEM_CODE = 6;


-- 구매 정보 테이블
CREATE TABLE SHOP_BUY (
	BUY_CODE INT AUTO_INCREMENT PRIMARY KEY
	, MEMBER_ID VARCHAR(20) NOT NULL REFERENCES shop_member (MEMBER_ID)
	, BUY_PRICE INT NOT NULL
	, BUY_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 구매 정보 상세 테이블
CREATE TABLE BUY_DETAIL (
	BUY_DETAIL_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
	, BUY_CNT INT NOT NULL
	, TOTAL_PRICE INT NOT NULL
	, BUY_CODE INT NOT NULL REFERENCES SHOP_BUY (BUY_CODE)
);


SELECT * FROM shop_buy
SELECT * FROM ..


-- IFNULL 앞 내용이  NULL이 나오면 뒤의 것으로 대체
SELECT IFNULL(MAX(BUY_CODE), 0) +1
FROM shop_buy;

-- 구매 날짜 및 총 구매 금액
SELECT BUY_DATE
		, BUY_PRICE
FROM shop_buy;
ORDER BY BUY_DATE DESC;

-- 상품코드, 상품명, 대표이미지명, 구매수량, 구매 가격
-- 조인, 서브쿼리
SELECT DETAIL.BUY_CODE
		, DETAIL.ITEM_CODE
		, ITEM_NAME
		, ATTACHED_FILE_NAME
		, BUY_CNT
		, TOTAL_PRICE
		, BUY_DATE
		, BUY_PRICE
FROM buy_detail DETAIL INNER JOIN shop_item ITEM
ON DETAIL.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_image IMG
ON DETAIL.ITEM_CODE = IMG.ITEM_CODE
INNER JOIN shop_buy BUY
ON DETAIL.BUY_CODE = BUY.BUY_CODE
WHERE IS_MAIN = 'Y'
AND MEMBER_ID = 'admin';

-- =
cart_view
SELECT ITEM_CODE
 		, BUY_CNT
 		, TOTAL_PRICE
 		, (SELECT ITEM_NAME
		FROM SHOP_ITEM
		WHERE ITEM_CODE = DETAIL.ITEM_CODE) ITEM_NAME
		, (SELECT ATTACHED_FILE_NAME
		FROM item_image
		WHERE ITEM_CODE = DETAIL.ITEM_CODE
		AND IS_MAIN = 'Y') ATTACHED_FILE_NAME
		, (SELECT BUY_DATE
		FROM SHOP_BUY
		WHERE BUY_CODE = DETAIL.BUY_CODE) BUY_DATE
FROM buy_detail DETAIL;