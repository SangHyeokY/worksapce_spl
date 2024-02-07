-- 데이터 조회
# 이것도 주석

-- 데이터 조회 1
-- SELECT 컬럼명들 FROM 테이블명;
-- 1. EMP 테이블에서 모든 사원의 사번, 이름, 급여정보 조회
SELECT EMPNO, ENAME, SAL FROM emp;

-- 2. 모든 사원의 이름, 직급, 입사일, 부서번호를 조회
SELECT ENAME, JOB, HIREDATE, DEPTNO FROM emp;

-- 3. 모든 사원의 모든 정보를 조회
-- *(에스테리스크) : ALL
SELECT * FROM emp;

-- 4. 조건을 통한 조회
-- 급여가 300 이상인 사원들의 사번, 사원명, 급여를 조회
SELECT EMPNO, ENAME, SAL 
FROM emp 
WHERE SAL >= 600;

-- 5. 직급이 대리인 사원들의 사원명, 직급, 급여를 조회
SELECT ENAME, JOB, SAL
FROM emp
WHERE JOB = '대리'; 

-- 6. 직급이 과장이고 급여가 400 이상인 사원들의 모든 정보를 조회
-- 같다 =, 같지않다 !=, <>
SELECT *
FROM emp
WHERE JOB = '과장' AND SAL >= 400;

-- 7. COMM이 NULL인 사원의 모든 정보를 조회
SELECT *
FROM emp
WHERE COMM IS NULL;
-- 반대로는 WHERE COMM IS NOT NULL;

-- 8. 급여가 500미만이거나 700이상이상이면서 직급은 차장이고 
-- 커미션은 NULL인 사원들의 사번, 사원명, 급여, 직급, 커미션 정보를 조회
SELECT EMPNO, ENAME, SAL, JOB, COMM
FROM emp
WHERE (SAL < 500 OR SAL >= 700)
AND JOB = '차장' AND COMM IS NULL;


SELECT * FROM emp;
-- LIKE 연산자, 와일드카드 
-- 와일드 카드 : %, _ 

-- % : 사이에 있는 글자를 의미, 갯수의 제한없음
-- _ : 사이에 있는 글자와 자신을 포함한 갯수

-- 사원명에서 '이'라는 글자가 포함된 사원을 조회
SELECT *
FROM emp
WHERE ENAME LIKE '%이%';

-- 사원명이 세글자이면서 중간 글자가 '이'인 사원을 조회
SELECT *
FROM emp
WHERE ENAME LIKE '_이_';

-- 사원명에서  세번째 글자가 '이'인 사원을 조회
SELECT *
FROM emp
WHERE ENAME LIKE '__이';


-- UPPER() : 대문자로 변경
-- LOWER() : 소문자로 변경
SELECT 'java', UPPER('java'), LOWER('JAVA');


-- BOARD 테이블에서 제목에 java라는 글자가 포함된
-- 게시글의 모든 내용을 조회하는 쿼리.
-- 단, java라는 글자는 대, 소문자
SELECT TITLE
FROM board
WHERE TITLE LIKE '%JAVA%';




