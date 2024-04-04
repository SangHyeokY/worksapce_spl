-- 1. 사원정보를 관리하는 테이블을 생성하려고 한다. 
-- 이 테이블에서 관리하는 정보로는 
-- 사원번호, 사원명, 부서번호, 직급, 부서명이 있다. 
-- 해당 테이블명을 MY_EMP라고 했을 때, 
-- 테이블  생성 쿼리문을 작성하세요. 
-- 단, 기본키는 사원번호로 하고 
-- 모든 정보는 NULL값을 허용하지 않는다.

-- 1)
CREATE TABLE MY_EMP_TEST (
	emp_num INT PRIMARY KEY
	, emp_name VARCHAR(10) NOT NULL
	, dept_num INT NOT NULL
	, job VARCHAR(10) NOT NULL
	, dept_name VARCHAR(10) NOT NULL
);

SELECT * FROM MY_EMP_TEST;

-- 2)
INSERT INTO MY_EMP_TEST 
VALUES (1, '김김김', 1, '사원', '사업부');

DELETE FROM MY_EMP_TEST;

-- 3)
UPDATE MY_EMP_TEST 
SET emp_name = '김자바'
	, job = '대리'
WHERE emp_num = 1;

-- ------------------------------------------------------------

-- 4) NULL이 아닌 값을 찾을 때는 IS NOT NULL
SELECT EMPNO
		, ENAME
		, SAL
		, COMM
FROM emp
WHERE (SAL <= 500 OR SAL >= 1500)
AND COMM IS NOT NULL;

-- 5) ~로 시작 'N%', ~로 끝 '%N'
SELECT EMPNO
		, ENAME
		, HIREDATE
FROM emp
WHERE ENAME LIKE '이%'
ORDER BY EMPNO ASC;

-- 6) 
SELECT EMPNO
		, ENAME
		, DEPTNO
		, CASE WHEN DEPTNO = 10 THEN '인사부'
				WHEN DEPTNO = 20 THEN '영업부'
				ELSE '생산부'
				END AS DNAME
FROM emp;

-- 7)
SELECT EMPNO
		, ENAME
		, HIREDATE
		, COMM
FROM emp
WHERE YEAR(HIREDATE) = 2007
ORDER BY HIREDATE ASC;

-- 8) ★어려움. 함수 외엔 GROUP BY한 데이터만 들어감 (JOB)
-- 만약, 커미션의 평균이 NULL이라면 0.0으로 조회
SELECT JOB
		, SUM(SAL)
		, AVG(SAL)
		, IFNULL(AVG(COMM), 0.0)
FROM emp
GROUP BY JOB
ORDER BY JOB ASC;

SELECT 10, 20, 10 + 20, NULL, NULL + 10;
-- 출력 : 10, 20, 30, NULL, NULL

SELECT COMM
		, IFNULL(COMM, 10)
FROM emp;

-- 입사한 월별 사원들의 급여의 합
SELECT DATE_FORMAT(HIREDATE, '%m')
		, SUM(SAL)
FROM emp
GROUP BY DATE_FORMAT(HIREDATE, '%m');

-- 1월에 입사한 사원들을 '제외'하고 입사한 월별 사원들의 입사자 수
SELECT DATE_FORMAT(HIREDATE, '%m') 입사월
		, COUNT(EMPNO)
FROM emp
WHERE DATE_FORMAT(HIREDATE, '%m') != '01'
GROUP BY DATE_FORMAT(HIREDATE, '%m');






-- 월별 입사자 수를 조회. 10월이 아닌
-- 월별 입사자 수가 2명 이상인 데이터만 조회
-- 조회 시 월별 입사자 수가 높은 순으로 조회
SELECT DATE_FORMAT(HIREDATE, '%m') 입사월
		, COUNT(EMPNO) 입사인원
FROM emp
WHERE DATE_FORMAT(HIREDATE, '%m') != '10'
GROUP BY 입사월
HAVING 입사인원 >= 2
ORDER BY 입사인원 DESC;

-- 해석순 1) FROM, 2) WHERE, 3) SELECT, 
-- 4) GROUP BY, 5) ORDER BY → 항상 마지막







-- 사원들의 입사 월을 조회
SELECT HIREDATE
		, SUBSTRING(HIREDATE, 6, 2)
		, DATE_FORMAT(HIREDATE, '%Y-%m-%d')
FROM emp;


-- 9) '서브쿼리'
SELECT EMPNO
		, ENAME
		, HIREDATE
		, SAL
		, DEPTNO
		, (SELECT dept.LOC 
			FROM dept 
			WHERE dept.DEPTNO = emp.DEPTNO) LOC
FROM emp
WHERE DEPTNO = (SELECT DEPTNO 
					FROM dept 
					WHERE LOC = '서울');


-- 10)
SELECT EMPNO
		, ENAME
		, HIREDATE
		, SAL
		, EMP.DEPTNO
		, LOC
FROM emp EMP
INNER JOIN dept DEPT
ON EMP.DEPTNO = DEPT.DEPTNO
WHERE LOC = '서울';




-- ● 풀이
-- GROUP BY : 통계 쿼리에서 사용
SELECT * FROM emp;

-- 중복을 제거한 데이터 조회
SELECT DISTINCT JOB FROM emp;
-- 출력 : 사원, 대리, 과장, 부장, 차장, 사장

-- 직원들의 급여의 합 조회
SELECT SUM(SAL)
FROM emp;

-- 각 직급별 급여의 합 조회
SELECT JOB, SUM(SAL)
FROM emp
GROUP BY JOB;

-- 부서번호별 인원 수 조회
-- COUNT 안에는 PK 넣는게 BEST
SELECT DEPTNO, COUNT(EMPNO)
FROM emp
GROUP BY DEPTNO;

-- 다중행 함수 : 데이터의 개수와 상관없이 조회결과가 1행만 나오는 함수
-- EX) COUNT(), SUM(), MAX(), MIN(), AVG()
-- 사번, 사원명, 모든 직원의 급여의 합을 조회
SELECT EMPNO
		, ENAME
		, SUM(SAL)
FROM emp;
-- 1행만 나오므로 옳지않음
