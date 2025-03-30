REM Q1.
/*Create TABLE Emp30100 as 
select employee_id, last_name, salary, department_name
from departments d, employees e
where d.department_id = e.department_id and e.department_id in (30, 100) ;
select * from Emp30100; */
CREATE OR REPLACE PROCEDURE Calc_bonus
    (empid IN number,
     bonus OUT number)
     IS
        sal integer;
     BEGIN
        select salary into sal from Emp30100
        where employee_id=empid;
        if sal >= 10000 then
            bonus :=2000;
        elsif sal >= 8000 then
            bonus :=1800;
        elsif sal >= 5000 then
            bonus :=1600;
        elsif sal >= 3000 then
            bonus :=1400;
        else
            bonus :=1200;
        END if;
END;
/
DECLARE
    v_empid Emp30100.employee_id%TYPE;
    v_bonus number;
    total_bonus number :=0;
    v_lastname Emp30100.last_name%TYPE;
    v_salary Emp30100.salary%TYPE;
    CURSOR c IS
    select employee_id, last_name, salary
    from Emp30100;
BEGIN
    dbms_output.put_line('ID    Last_Name      Salary       Bonus');
    dbms_output.put_line('----  ---------     --------      -------');
    OPEN c;
    Loop
        FETCH c INTO v_empid, v_lastname, v_salary;
        EXIT WHEN c%NOTFOUND;
        Calc_bonus(v_empid, v_bonus);
        dbms_output.put_line(RPAD(v_empid, 7) || RPAD(v_lastname, 13) ||
        RPAD(to_char(v_salary, '$99,999'), 12) || to_char(v_bonus, '$99,999'));
        total_bonus :=total_bonus+v_bonus;
    END Loop;
    CLOSE c;
    dbms_output.put_line(chr(10));
    dbms_output.put_line('Total bonus are' || to_char(total_bonus, '$99,999'));
END;
/
Output of Q1:
ID    Last_Name      Salary       Bonus
----  ---------     --------      -------
114    Raphaely      $11,000      $2,000
115    Khoo           $3,100      $1,400
116    Baida          $2,900      $1,200
117    Tobias         $2,800      $1,200
118    Himuro         $2,600      $1,200
119    Colmenares     $2,500      $1,200
108    Greenberg     $12,000      $2,000
109    Faviet         $9,000      $1,800
110    Chen           $8,200      $1,800
111    Sciarra        $7,700      $1,600
112    Urman          $7,800      $1,600
113    Popp           $6,900      $1,600

REM Q2.
DECLARE
    TYPE Emp_info IS RECORD(
    empno Emp30100.employee_id%TYPE,
    lastname Emp30100.last_name%TYPE,
    sal number);
    TYPE Emp_sal IS TABLE OF Emp_info;
    v Emp_sal :=Emp_sal();
    CURSOR c IS
    select employee_id, last_name, salary
    from Emp30100;
    counter integer :=1;
BEGIN
    dbms_output.put_line('ID    Last_Name      Salary');
    dbms_output.put_line('---   ---------      -------');
    for indx in c Loop
        v.extend;
        v(counter).empno :=indx.employee_id;
        v(counter).lastname :=indx.last_name;
        v(counter).sal :=indx.salary;
        dbms_output.put_line(RPAD(v(counter).empno, 7) ||
        RPAD(v(counter).lastname, 13) || to_char(v(counter).sal, '$99,999'));
        counter :=counter+1;
    END Loop;
END;
/
Output of Q2:
ID    Last_Name      Salary
---   ---------      -------
114    Raphaely      $11,000
115    Khoo           $3,100
116    Baida          $2,900
117    Tobias         $2,800
118    Himuro         $2,600
119    Colmenares     $2,500
108    Greenberg     $12,000
109    Faviet         $9,000
110    Chen           $8,200
111    Sciarra        $7,700
112    Urman          $7,800
113    Popp           $6,900

REM Q3.
CREATE OR REPLACE PACKAGE emp30100_admin IS
    FUNCTION Add_emp(
        lastname emp30100.last_name%TYPE,
        sal emp30100.salary%TYPE,
        deptname emp30100.department_name%TYPE
        ) return number;
    PROCEDURE Change_sal(empid number, amount number);
    PROCEDURE Change_sal(emp_lastname varchar2, amount number);
    PROCEDURE Delete_emp(empid number);
END emp30100_admin;
/
CREATE OR REPLACE PACKAGE BODY emp30100_admin IS
    FUNCTION Add_emp(
        lastname emp30100.last_name%TYPE,
        sal emp30100.salary%TYPE,
        deptname emp30100.department_name%TYPE
        ) return number
        IS
        new_empid number;
        max_empid number;
        BEGIN
            select max(employee_id) into max_empid
            from emp30100;
            new_empid :=max_empid+1;
            insert into emp30100
            values(new_empid, lastname, sal, deptname);
            return new_empid;
    END Add_emp;
    PROCEDURE Change_sal(empid number, amount number)
    IS
    BEGIN
        update emp30100
        set salary=salary+amount
        where employee_id=empid;
    END Change_sal;
    PROCEDURE Change_sal(emp_lastname varchar2, amount number)
    IS
    BEGIN
        update emp30100
        set salary=salary+amount
        where last_name=emp_lastname;
    END Change_sal;
    PROCEDURE Delete_emp(empid number)
    IS
    BEGIN
        delete from emp30100
        where employee_id=empid;
    END Delete_emp;
END emp30100_admin;
/
DECLARE
    lname varchar2(45) :='Ford';
    sal number :=4000;
    deptname varchar2(45) :='Finance';
    empid number;
    c_sal number;
BEGIN
    empid :=emp30100_admin.Add_emp(lname, sal, deptname);
    dbms_output.put_line('The new employee ID is ' || empid || chr(10));
    emp30100_admin.Change_sal(empid, 100);
    select salary into c_sal from emp30100 where employee_id=empid;
    dbms_output.put_line('The fisrt new salary for emplyee ID ' || empid ||
    ' is' || to_char(c_sal, '$99,999'));
    emp30100_admin.Change_sal(lname, 99);
    select salary into c_sal from emp30100 where employee_id=empid;
    dbms_output.put_line('The secod new salary for emplyee ID ' || empid ||
    ' is' || to_char(c_sal, '$99,999'));
    emp30100_admin.Delete_emp(empid);
END;
Output of Q3:
The new employee ID is 120

The fisrt new salary for emplyee ID 120 is  $4,100
The secod new salary for emplyee ID 120 is  $4,199

REM Q4.
DECLARE
    query_str VARCHAR2(100) := 'SELECT count(*) FROM emp30100 WHERE salary >= :amount';
    amount NUMBER := 5000;
    total NUMBER;
BEGIN
    EXECUTE IMMEDIATE query_str INTO total USING amount;
    DBMS_OUTPUT.PUT_LINE('There are ' || total || ' employees whose salaries are equal to or greater than $5000.');
END;
/
Output of Q4:
There are 7 employees whose salaries are equal to or greater than $5000.

REM Q5.
CREATE TABLE Emp30100_log(
    EMPNO number(4),
    Last_name varchar2(45),
    OLD_SAL number(7,2),
    NEW_SAL number(7,2),
    OLD_DEPT varchar2(50),
    NEW_DEPT varchar2(50),
    Updated_Date DATE,
	Updated_By varchar2(15),
	Action	varchar2(30)
);
CREATE OR REPLACE TRIGGER Emp30100_monitor
AFTER INSERT OR DELETE OR UPDATE OF salary, department_name ON Emp30100
FOR EACH ROW
BEGIN
    if INSERTING then
        insert into emp30100_log 
        values(:NEW.employee_id, :NEW.last_name, null, :NEW.salary, null,
        :NEW.department_name, sysdate, user, 'New row inserted.');
    elsif DELETING then
        insert into emp30100_log
        values(:OLD.employee_id, :OLD.last_name, :OLD.salary, null, :OLD.department_name,
        null, sysdate, user, 'A row has been deleted.');
    elsif UPDATING('salary') then
        insert into emp30100_log
        values(:NEW.employee_id, :NEW.last_name, :OLD.salary, :NEW.salary, :OLD.department_name,
        null, sysdate, user, 'Salary changed.');
    elsif UPDATING('department_name') then
        insert into emp30100_log
        values(:NEW.employee_id, :NEW.last_name, :OLD.salary, null, :OLD.department_name, 
        :NEW.department_name, sysdate, user, 'Department Name changed.');
    else 
        dbms_output.put_line('Something went wrong.');
    END if;
END;
/
/*INSERT INTO Emp30100 VALUES 
(201, 'Great', 3500, 'Finance');
UPDATE Emp30100
SET salary = 3600 WHERE employee_id = 201;
UPDATE Emp30100
SET  department_name = 'Purchase' WHERE employee_id = 201;
UPDATE Emp30100
SET  last_name  = 'Notgreat' WHERE employee_id = 201;
DELETE Emp30100 WHERE  employee_id = 201;*/
-- SELECT * FROM emp30100_log ;
-- ROLLBACK;
Output of Q5:

     EMPNO LAST_NAME                                        OLD_SAL    NEW_SAL OLD_DEPT                                           NEW_DEPT                                           UPDATED_D UPDATED_BY      ACTION                        
---------- --------------------------------------------- ---------- ---------- -------------------------------------------------- -------------------------------------------------- --------- --------------- ------------------------------
       201 Great                                                          3500                                                    Finance                                            18-NOV-24 YTSAI15         New row inserted.             
       201 Great                                               3500       3600 Finance                                                                                               18-NOV-24 YTSAI15         Salary changed.               
       201 Great                                               3600            Finance                                            Purchase                                           18-NOV-24 YTSAI15         Department Name changed.      
       201 Notgreat                                            3600            Purchase                                                                                              18-NOV-24 YTSAI15         A row has been deleted.       
