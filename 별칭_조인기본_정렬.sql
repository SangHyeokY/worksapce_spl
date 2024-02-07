-- 별칭 사용(조회 시 컬럼명을 변경)
-- 컬럼명을 조회할때는 테이블명.컬럼명으로 조회
-- 통상적으로 테이블명.~은 생략
-- 별칭을 넣음으로서 중복된 컬럼명끼리 구분이 가능

-- 1. 정의하기
SELECT EMP.EMPNO
		 , EMP.ENAME
		 , EMP.SAL
FROM emp;

-- 2. AS + 뒷글자(별칭)으로 바꾸기
SELECT EMPNO AS 사번
		 , ENAME AS NM
		 , SAL 급여
FROM emp;

-- 3. 별칭 E를 정의하고 E.컬럼명
SELECT E.EMPNO
		 , E.ENAME
		 , E.SAL
FROM emp E;


-- join
SELECT * FROM emp;
SELECT * FROM dept;


-- 사원의 사번, 이름, 부서명을 조회
-- 1. CROSS JOIN(공부를 위해 학습하는거지, 실무에서 X)
-- 가지치기로 이어짐. 틀린 데이터 다수. 합집합 조회
SELECT EMPNO, ENAME, DNAME
FROM emp CROSS JOIN dept;


-- 2. INNER JOIN(교집합 데이터 조회)
-- ON : 조인하는 두 테이블이 공통적으로 지니는 컬럼의
-- 값이 같다.라는 조건을 줄 것!
SELECT EMPNO, ENAME, DNAME
FROM emp INNER JOIN dept
ON emp.DEPTNO = dept.DEPTNO;

SELECT EMPNO, ENAME, DNAME, D.DEPTNO
FROM emp E INNER JOIN dept D
ON E.DEPTNO = D.DEPTNO;


-- 데이터 조회 시 정렬하여 출력하기
-- 사원의 모든 정보를 조회하되, 급여가 낮은 순부터 조회
-- 오름차순 : ASC, 생략가능
-- 내림차순 : DESC
SELECT *
FROM emp
ORDER BY SAL; -- ASCENDING 'ASC' <-> DESCENDING 'DESC'

-- 사원의 모든 데이터를 조회하되, 급여 기준 내림차순 정렬
-- 급여가 같다면 사번기준 오름차순 정렬
SELECT *
FROM emp
ORDER BY SAL DESC, EMPNO ASC;
-- 쉼표로 이어짐



-- Q. 급여가 200 이상이면서 커미션은 NUMLL이 아닌 
-- 사원의 사번, 이름, 급여, 부서번호, 부서명을 조회
-- 단, 부서번호 기준 오름차순 정렬 후
-- 부서번호가 같다면 급여 기준 내림차순으로 정렬
-- 추가적으로 사번은 '사원번호'라는 별칭을 사용해서 조회
-- @@@순서가 정해져 있음@@@
-- @@@DEPTNO는 EMP와 DEPT에 동시에 존재@@@

SELECT EMPNO AS 사원번호
		, ENAME
		, SAL	
		, EMP.DEPTNO
		, DNAME
FROM emp INNER JOIN dept
ON emp.DEPTNO = dept.DEPTNO
WHERE SAL >= 200 AND COMM IS NOT NULL
ORDER BY emp.DEPTNO, SAL DESC;


