REM Q3.
DECLARE
    Exceed_Limit EXCEPTION;
    counter number :=10;
BEGIN
    Loop
        if counter > 12 then 
            RAISE EXceed_Limit;
        end if;
        dbms_output.put_line('Current counter is ' || counter);
        counter :=counter+1;
    END Loop;
EXCEPTION
    WHEN Exceed_Limit then
        dbms_output.put_line('Error, ' || counter|| ' has exceeded the limit of 12!');
END;
/
Output of Q3:
Current counter is 10
Current counter is 11
Current counter is 12
Error, 13 has exceeded the limit of 12!

REM Q4(a).
DECLARE
    Error_Sal EXCEPTION;
    min_sal number :=1200;
    CURSOR c IS
    select empno, sal, deptno
    from emp;
BEGIN
    DBMS_OUTPUT.put_line  ('Emp ID     Salary      DeptNo ');     
    DBMS_OUTPUT.put_line  ('------   -----------   --------'); 
    for indx in c Loop
        if indx.sal < min_sal then
            dbms_output.put_line(RPAD(indx.empno,12) || to_char(indx.sal, '$99,999') ||
            LPAD(indx.deptno, 8));
            RAISE Error_sal;
        else
            dbms_output.put_line('Salary ' || indx.sal || ' is fine.');
        end if;
    END Loop;
EXCEPTION
    WHEN Error_Sal then
        Null;
END;
/
Output of Q4(a):
Emp ID     Salary      DeptNo 
------   -----------   --------
7369            $800      20

REM Q4(b).
DECLARE
    Error_Sal EXCEPTION;
    min_sal number :=1200;
    counter number :=0;
    CURSOR c IS
    select empno, sal, deptno
    from emp;
BEGIN
    DBMS_OUTPUT.put_line  ('Emp ID     Salary      DeptNo ');     
    DBMS_OUTPUT.put_line  ('------   -----------   --------'); 
    for indx in c Loop
        BEGIN
            if indx.sal < min_sal then
                dbms_output.put_line(RPAD(indx.empno,12) || to_char(indx.sal, '$99,999') ||
                LPAD(indx.deptno, 8));
                RAISE Error_sal;
            END if;
        EXCEPTION
            WHEN Error_Sal then 
                counter :=counter+1;
        END;
    END Loop;
    if counter = 0 then
        dbms_output.put_line('No employee has salary lower than the limit.');
    else
        dbms_output.put_line(CHR(10) || 'There are ' || counter || 
        ' employees, their salaries are lower than the limit.');
    END if;
END;
/
Output of Q4(b):
Emp ID     Salary      DeptNo 
------   -----------   --------
7369            $800      20
7876          $1,100      20
7900            $950      30

There are 3 employees, their salaries are lower than the limit.

REM Q5.
CREATE TABLE log_error (
  Occur_date  DATE DEFAULT SYSDATE,
  Username    VARCHAR2 (15) DEFAULT USER,
  Err_code    NUMBER,
  Err_msg     VARCHAR2 (255));

DECLARE
    dept_id number(4):=220;
    Err_code number;
    Err_msg varchar2(255);
BEGIN
    DELETE FROM EMPLOYEES
    WHERE department_id=dept_id;
    rollback;
    dept_id :=30;
    DELETE FROM EMPLOYEES
    WHERE department_id=dept_id;
    rollback;
EXCEPTION
    WHEN OTHERS THEN
        Err_code :=SQLCODE;
        Err_msg :=SQLERRM;
        INSERT INTO log_error
        VALUES(SYSDATE, USER, Err_code, Err_msg);
END;

select * from log_error;
Output of Q5:
OCCUR_DAT USERNAME          ERR_CODE ERR_MSG                                                                                                                                                                                                                                                        
--------- --------------- ---------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
05-OCT-24 YTSAI15              -2292 ORA-02292: integrity constraint (YTSAI15.JHIST_EMP_FK) violated - child record found                                                                                                                                                                           

REM Q6.
DECLARE
    Child_FK EXCEPTION;
    PRAGMA EXCEPTION_INIT(Child_FK, -2292);
    dept_id number(4):=220;
    error_code number;
    error_msg varchar2(255);
BEGIN
    DELETE FROM EMPLOYEES
    WHERE department_id=dept_id;
    rollback;
    dept_id :=30;
    DELETE FROM EMPLOYEES
    WHERE department_id=dept_id;
    rollback;
EXCEPTION
    WHEN Child_FK THEN
        error_code :=SQLCODE;
        error_msg :=SQLERRM;
        INSERT INTO log_error
        VALUES(SYSDATE, USER, error_code, error_msg);
END;

select * from log_error;      
Output of Q6:
OCCUR_DAT USERNAME          ERR_CODE ERR_MSG                                                                                                                                                                                                                                                        
--------- --------------- ---------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
05-OCT-24 YTSAI15              -2292 ORA-02292: integrity constraint (YTSAI15.JHIST_EMP_FK) violated - child record found                                                                                                                                                                           

              
            

