-- 현재 쿼리 탭에서는 AUTOCOMMIT을 비활성화
SET @@AUTOCOMMIT=0;

-- 데이터의 변경사항을 취소
ROLLBACK;

-- 데이터의 변경사항을 저장
COMMIT;



-- 공부용 테이블 생성
CREATE TABLE STUDENT (
	STU_NO INT PRIMARY KEY
	, STU_NAME VARCHAR(10)
	, SCORE INT
	, ADDR VARCHAR(20)
); 

SELECT * FROM student;

-- 데이터 삽입
-- INSERT INTO 테이블명(컬럼들) VALUES(값들);
INSERT INTO student (STU_NO, STU_NAME, SCORE, ADDR) 
VALUES (1, '김자바', 80, '울산');

INSERT INTO student (STU_NO, STU_NAME) 
VALUES (2, '이자바');

-- 순서가 달라도 됨
INSERT INTO student (STU_NAME, STU_NO)
VALUES ('최자바', 3);

COMMIT;

-- 당연히 PRIMARY값에 NULL값이 들어가므로 오류남
INSERT INTO student (STU_NAME, SCORE)
VALUES ('최자바', 90);

-- 괄호 생략 가능
-- 컬럼명을 명시하지 않으면 테이블 생성 시
-- 작성한 컬럼순으로 데이터를 삽입
INSERT INTO student VALUES (5, '고길동', 80, '서울');
COMMIT;




SELECT * FROM student;
-- 데이터 삭제
-- DELETE FROM 테이블명 WHERE 조건;
-- FROM, WHERE 생략 가능

DELETE FROM student;
DELETE student;
ROLLBACK;

-- 학번이 1번인 학생을 삭제하는 쿼리
DELETE FROM student
WHERE STU_NO=1;

-- 학번이 3번 이상이면서 주소가 NULL인 학생을 삭제하는 쿼리
DELETE FROM student
WHERE STU_NO>=3 AND ADDR IS NULL;
COMMIT;
