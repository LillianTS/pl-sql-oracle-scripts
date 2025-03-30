REM Q1.
CREATE TABLE Emp_log(
   Updated_Date	DATE,
   Updated_by Varchar2 (20),
   Action     Varchar2 (30)
);
CREATE OR REPLACE TRIGGER Emp_Delete
AFTER DELETE ON employees
BEGIN
    insert into Emp_log
    values(sysdate, user, 'Table Changed');
END Emp_Delete;
DELETE FROM employees where salary < 2300;
select * from Emp_log;
--rollback;
--Drop TRIGGER Emp_Delete;
Output of Q1:
UPDATED_D UPDATED_BY           ACTION                        
--------- -------------------- ------------------------------
07-NOV-24 YTSAI15              Table Changed  

REM Q2.
CREATE TABLE Emp_Del_log (
   Empno      number (4),
   OLD_name   Varchar2 (20),
   OLD_sal     number (8, 2),
   OLD_mgrno   number (4),  
   Updated_Date	DATE,
   Updated_By	Varchar2 (15),
   Action       Varchar2 (30)
);
CREATE OR REPLACE TRIGGER Emp_Del_Row
AFTER DELETE ON emp
FOR EACH ROW
BEGIN
    insert into Emp_Del_log
    values(:Old.empno, :OLD.ename, :OLD.sal, :OLD.mgr, sysdate, user, 'Records deleted');
END Emp_Del_Row;
DELETE FROM emp where mgr=7698;
select * from Emp_Del_log;
--rollback;
--Drop Trigger Emp_Del_log;
Output of Q2:
     EMPNO OLD_NAME                OLD_SAL  OLD_MGRNO UPDATED_D UPDATED_BY      ACTION                        
---------- -------------------- ---------- ---------- --------- --------------- ------------------------------
      7499 ALLEN                      1600       7698 08-NOV-24 YTSAI15         Records deleted               
      7521 WARD                       1250       7698 08-NOV-24 YTSAI15         Records deleted               
      7654 MARTIN                     1250       7698 08-NOV-24 YTSAI15         Records deleted               
      7844 TURNER                     1500       7698 08-NOV-24 YTSAI15         Records deleted               
      7900 JAMES                       950       7698 08-NOV-24 YTSAI15         Records deleted               

REM Q3.
CREATE TABLE      Dept_log(
   OLD_Deptno     number (4),
   NEW_Deptno     number (4),
   OLD_Deptname   Varchar2 (10),
   NEW_Deptname   Varchar2 (10),
   OLD_MgrID      number (6),
   NEW_MgrID      number (6),
   Updated_Date	DATE,
   Updated_By	Varchar2 (15),
   Action         Varchar2 (30)
);
CREATE OR REPLACE TRIGGER Dept_Change
AFTER INSERT OR DELETE OR UPDATE OF manager_id on departments
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        insert into Dept_log
        values(null, :NEW.department_id, null, :NEW.department_name, null, :NEW.manager_id,
        sysdate, user, 'Add new department.');
    ELSIF DELETING THEN
        insert into Dept_log
        values(:OLD.department_id, null, :OLD.department_name, null, :OLD.manager_id,
        null, sysdate, user, 'Department deleted.');
    ELSIF UPDATING('manager_id') THEN
        insert into Dept_log
        values(:OLD.department_id, :NEW.department_id, :OLD.department_name, :NEW.department_name,
        :OLD.manager_id, :NEW.manager_id, sysdate, user, 'manager_id changed.');
    ELSE
        dbms_output.put_line('something goes wrong.');
    END if;
END Dept_Change;
INSERT INTO departments VALUES (999, 'Test', null, 1700);
UPDATE departments set manager_id = 103  WHERE department_id = 999;
DELETE departments where department_id = 999;
SELECT * from Dept_log ;
--rollback;
--Drop TRIGGER Dept_Change;
Output of Q3:
OLD_DEPTNO NEW_DEPTNO OLD_DEPTNA NEW_DEPTNA  OLD_MGRID  NEW_MGRID UPDATED_D UPDATED_BY      ACTION                        
---------- ---------- ---------- ---------- ---------- ---------- --------- --------------- ------------------------------
                  999            Test                             08-NOV-24 YTSAI15         Add new department.           
       999        999 Test       Test                         103 08-NOV-24 YTSAI15         manager_id changed.           
       999            Test                         103            08-NOV-24 YTSAI15         Department deleted.    

REM Q4.
CREATE OR REPLACE PACKAGE Pack_Dept IS
    TYPE Dept_Info IS RECORD(
        dept_id departments.department_id%TYPE,
        dept_name departments.department_name%TYPE,
        city varchar2(30),
        number_worker number
    );
    FUNCTION Get_dept_info(
        dept_no number)
        return Dept_Info;
    FUNCTION Get_dept_info(
        dept_name varchar2)
        return Dept_info;
END Pack_dept;
/
CREATE OR REPLACE PACKAGE BODY Pack_Dept IS
    FUNCTION Get_dept_info(
        dept_no number)
        RETURN Dept_Info
        IS
        r Dept_Info;
    BEGIN
        SELECT d.department_id, d.department_name
        INTO r.dept_id, r.dept_name
        FROM departments d
        WHERE d.department_id = dept_no;
        SELECT l.city
        INTO r.city
        FROM locations l
        JOIN departments d
            ON l.location_id = d.location_id
        WHERE d.department_id = dept_no;
        SELECT COUNT(*)
        INTO r.number_worker
        FROM employees e
        WHERE e.department_id = dept_no;
        RETURN r;
    END Get_dept_info;

    FUNCTION Get_dept_info(
        dept_name varchar2)
        RETURN Dept_Info
        IS
        r Dept_Info;
    BEGIN
        SELECT d.department_id, d.department_name
        INTO r.dept_id, r.dept_name
        FROM departments d
        WHERE d.department_name = dept_name;
        SELECT l.city
        INTO r.city
        FROM locations l
        JOIN departments d
            ON l.location_id = d.location_id
        WHERE d.department_name = dept_name;
        SELECT COUNT(*)
        INTO r.number_worker
        FROM employees e
        join departments d
            on e.department_id=d.department_id
        WHERE d.department_name = dept_name;
        RETURN r;
    END Get_dept_info;
END Pack_Dept;
/
DECLARE
    v Pack_dept.dept_Info;
    CURSOR c IS
    select department_name
    from departments
    where manager_id is not null;
BEGIN
    dbms_output.put_line('Department ID   Department Name      City           Number of employees');
    dbms_output.put_line('-----------     ---------------      ---------      ------------------');
    v :=Pack_Dept.Get_dept_info(60);
    dbms_output.put_line(RPAD(v.dept_id, 17) || RPAD(v.dept_name, 20) 
    || RPAD(v.city, 18) || v.number_worker);
    dbms_output.put_line('');
    for indx in c Loop
        v :=Pack_Dept.Get_dept_info(indx.department_name);
        dbms_output.put_line(RPAD(v.dept_id, 17) || RPAD(v.dept_name, 20) 
        || RPAD(v.city, 18) || v.number_worker);
    END Loop;
END;
Output of Q4:
     Department ID   Department Name      City           Number of employees
-----------     ---------------      ---------      ------------------
60               IT                  Southlake         5

10               Administration      Seattle           1
20               Marketing           Toronto           2
30               Purchasing          Seattle           6
40               Human Resources     London            1
50               Shipping            San Francisco     45
60               IT                  Southlake         5
70               Public Relations    Munich            1
80               Sales               Oxford            34
90               Executive           Seattle           3
100              Finance             Seattle           6
110              Accounting          Seattle           2
  


