REM Q1.
DECLARE
    CURSOR c IS
    SELECT last_name ||', ' || first_name as Full_name,  
    salary, manager_id
    FROM employees 
    WHERE  department_id = 80 and salary >= 12000 ;
BEGIN
    DBMS_OUTPUT.put_line (' No      Emp Full Name            Salary        Boss ID');    
    DBMS_OUTPUT.put_line  ('----  ------------------------  ------------  ---------'); 
    for indx in c Loop
         DBMS_OUTPUT.put_line (RPAD (c%ROWCOUNT, 7) || RPAD (indx.Full_name, 25) 
         || To_Char (indx.salary, '$99,999') || LPAD (indx.manager_id, 13));
    END Loop;
END;
Output of Q1:
No      Emp Full Name            Salary        Boss ID
----  ------------------------  ------------  ---------
1      Russell, John             $14,000          100
2      Partners, Karen           $13,500          100
3      Errazuriz, Alberto        $12,000          100

REM Q2.
DECLARE
    CURSOR c IS
    select employee_id, commission_pct, salary
    from employees
    where department_id=80;
    emp_id employees.employee_id%TYPE;
    comm employees.commission_pct%TYPE;
    sal employees.salary%TYPE;
    bonus number :=0;
    total_bonus number :=0;
BEGIN
    OPEN c;
    Loop
        FETCH c into emp_id, comm, sal;
        EXIT WHEN c%NOTFOUND;
        if comm >= 0.3 then 
            if sal >= 10000 then
                bonus :=1500;
            elsif sal >= 7000 then
                bonus :=1400;
            else
                bonus :=1300;
            end if;
        elsif comm >=0.2 then
            if sal >=10000 then
                bonus :=1300;
            elsif sal >=7000 then
                bonus :=1200;
            else
                bonus :=1100;
            end if;
        elsif comm >=0.1 then
            if sal >=10000 then
                bonus :=1100;
            elsif sal >=7000 then
                bonus :=1000;
            else
                bonus :=900;
            end if;
        else
            bonus :=800;
        end if;
        dbms_output.put_line('Employee with ID ' || emp_id || ', his(her) salary is' ||
        to_char(sal, '$99,999') || '; commission rate is ' || NVL(comm, 0) ||
        ' with bonus is' || to_char(bonus, '$99,999') ||'.');
        total_bonus :=total_bonus+bonus;
    END Loop;
    CLOSE c;
    dbms_output.put_line(' ');
    dbms_output.put_line('Total amount of the bonus for department 80 is' || 
    to_char(total_bonus, '$99,999') ||'.');
END;
Output of Q2:
Employee with ID 145, his(her) salary is $14,000; commission rate is .4 with bonus is  $1,500.
Employee with ID 146, his(her) salary is $13,500; commission rate is .3 with bonus is  $1,500.
Employee with ID 147, his(her) salary is $12,000; commission rate is .3 with bonus is  $1,500.
Employee with ID 148, his(her) salary is $11,000; commission rate is .3 with bonus is  $1,500.
Employee with ID 149, his(her) salary is $10,500; commission rate is .2 with bonus is  $1,300.
Employee with ID 150, his(her) salary is $10,000; commission rate is .3 with bonus is  $1,500.
Employee with ID 151, his(her) salary is  $9,500; commission rate is .25 with bonus is  $1,200.
Employee with ID 152, his(her) salary is  $9,000; commission rate is .25 with bonus is  $1,200.
Employee with ID 153, his(her) salary is  $8,000; commission rate is .2 with bonus is  $1,200.
Employee with ID 154, his(her) salary is  $7,500; commission rate is .2 with bonus is  $1,200.
Employee with ID 155, his(her) salary is  $7,000; commission rate is .15 with bonus is  $1,000.
Employee with ID 156, his(her) salary is $10,000; commission rate is .35 with bonus is  $1,500.
Employee with ID 157, his(her) salary is  $9,500; commission rate is .35 with bonus is  $1,400.
Employee with ID 158, his(her) salary is  $9,000; commission rate is .35 with bonus is  $1,400.
Employee with ID 159, his(her) salary is  $8,000; commission rate is .3 with bonus is  $1,400.
Employee with ID 160, his(her) salary is  $7,500; commission rate is .3 with bonus is  $1,400.
Employee with ID 161, his(her) salary is  $7,000; commission rate is .25 with bonus is  $1,200.
Employee with ID 162, his(her) salary is $10,500; commission rate is .25 with bonus is  $1,300.
Employee with ID 163, his(her) salary is  $9,500; commission rate is .15 with bonus is  $1,000.
Employee with ID 164, his(her) salary is  $7,200; commission rate is .1 with bonus is  $1,000.
Employee with ID 165, his(her) salary is  $6,800; commission rate is .1 with bonus is    $900.
Employee with ID 166, his(her) salary is  $6,400; commission rate is .1 with bonus is    $900.
Employee with ID 167, his(her) salary is  $6,200; commission rate is .1 with bonus is    $900.
Employee with ID 168, his(her) salary is $11,500; commission rate is .25 with bonus is  $1,300.
Employee with ID 169, his(her) salary is $10,000; commission rate is .2 with bonus is  $1,300.
Employee with ID 170, his(her) salary is  $9,600; commission rate is .2 with bonus is  $1,200.
Employee with ID 171, his(her) salary is  $7,400; commission rate is .15 with bonus is  $1,000.
Employee with ID 172, his(her) salary is  $7,300; commission rate is .15 with bonus is  $1,000.
Employee with ID 173, his(her) salary is  $6,100; commission rate is .1 with bonus is    $900.
Employee with ID 174, his(her) salary is $11,000; commission rate is .3 with bonus is  $1,500.
Employee with ID 175, his(her) salary is  $8,800; commission rate is .25 with bonus is  $1,200.
Employee with ID 176, his(her) salary is  $8,600; commission rate is .2 with bonus is  $1,200.
Employee with ID 177, his(her) salary is  $8,400; commission rate is .2 with bonus is  $1,200.
Employee with ID 179, his(her) salary is  $6,200; commission rate is .1 with bonus is    $900.
 
Total amount of the bonus for department 80 is $41,600.

REM Q3.
DECLARE
    CURSOR c(tname_in varchar2) IS
    select table_name, column_name, data_type, data_length 
    from user_tab_columns
    where table_name=tname_in;
BEGIN
    dbms_output.put_line('Table name: LOCATIONS: ');
    for indx in c('LOCATIONS') Loop
        dbms_output.put_line('Column name: ' || indx.column_name || '; Data type: ' ||
        indx.data_type || '; Data length: ' || indx.data_length ||'.');
    END Loop;
    dbms_output.put_line('----------------------------------------------');
    dbms_output.put_line('Table name: EMPLOYEES: ');
    for indx in c('EMPLOYEES') Loop
        dbms_output.put_line('Column name: ' || indx.column_name || '; Data type: ' ||
        indx.data_type || '; Data length: ' || indx.data_length ||'.');
    END Loop;
END;
Output of Q3:
Table name: LOCATIONS: 
Column name: LOCATION_ID; Data type: NUMBER; Data length: 22.
Column name: STREET_ADDRESS; Data type: VARCHAR2; Data length: 40.
Column name: POSTAL_CODE; Data type: VARCHAR2; Data length: 12.
Column name: CITY; Data type: VARCHAR2; Data length: 30.
Column name: STATE_PROVINCE; Data type: VARCHAR2; Data length: 25.
Column name: COUNTRY_ID; Data type: CHAR; Data length: 2.
----------------------------------------------
Table name: EMPLOYEES: 
Column name: EMPLOYEE_ID; Data type: NUMBER; Data length: 22.
Column name: FIRST_NAME; Data type: VARCHAR2; Data length: 20.
Column name: LAST_NAME; Data type: VARCHAR2; Data length: 25.
Column name: EMAIL; Data type: VARCHAR2; Data length: 25.
Column name: PHONE_NUMBER; Data type: VARCHAR2; Data length: 20.
Column name: HIRE_DATE; Data type: DATE; Data length: 7.
Column name: JOB_ID; Data type: VARCHAR2; Data length: 10.
Column name: SALARY; Data type: NUMBER; Data length: 22.
Column name: COMMISSION_PCT; Data type: NUMBER; Data length: 22.
Column name: MANAGER_ID; Data type: NUMBER; Data length: 22.
Column name: DEPARTMENT_ID; Data type: NUMBER; Data length: 22.

REM Q4.
DROP table Emply_temp; 
Create table Emply_temp AS
select * 
from employees 
where department_id = 80;
DECLARE
    CURSOR c IS
    select employee_id, last_name, salary, commission_pct
    from Emply_temp
    for update of salary;
    emp_id  employees.employee_id%TYPE;
    emp_last_name employees.last_name%TYPE;
    sal employees.salary%TYPE;
    old_sal employees.salary%TYPE;
    comm employees.commission_pct%TYPE;
BEGIN
    OPEN c;
    Loop
        FETCH c into emp_id, emp_last_name, sal, comm;
        EXIT WHEN c%NOTFOUND;
        if comm < 0.15 then
            old_sal :=sal;
            sal :=sal*1.08;
            UPDATE Emply_temp
            SET salary=sal
            WHERE CURRENT OF c;
            dbms_output.put_line('Employee with ID ' || emp_id || 
            ', his(her) last name is ' || emp_last_name || '; his(her) old salary is' || 
            to_char(old_sal, '$99,999') || chr(10) || ', and his(her) new salary is' || 
            to_char(sal, '$99,999') ||'.');
        END if;
    END Loop;
    CLOSE c;
END;
Output of Q4:
Employee with ID 164, his(her) last name is Marvins; his(her) old salary is  $7,776
, and his(her) new salary is  $8,398.
Employee with ID 165, his(her) last name is Lee; his(her) old salary is  $7,344
, and his(her) new salary is  $7,932.
Employee with ID 166, his(her) last name is Ande; his(her) old salary is  $6,912
, and his(her) new salary is  $7,465.
Employee with ID 167, his(her) last name is Banda; his(her) old salary is  $6,696
, and his(her) new salary is  $7,232.
Employee with ID 173, his(her) last name is Kumar; his(her) old salary is  $6,588
, and his(her) new salary is  $7,115.
Employee with ID 179, his(her) last name is Johnson; his(her) old salary is  $6,696
, and his(her) new salary is  $7,232.

REM Q5.
DECLARE
    TYPE EmpCurTyp IS REF CURSOR RETURN Employees%ROWTYPE;
    Emp EmpCurTyp;
    dept_id number(4) :=60;
    allemp employees%ROWTYPE;
BEGIN
    OPEN Emp FOR 
    select * 
    from employees
    where department_id=dept_id
    order by last_name;
    Loop
        FETCH Emp into allemp;
        EXIT WHEN Emp%NOTFOUND;
        dbms_output.put_line('Employee with ID ' || allemp.employee_id ||
        ', his(her) full name is ' || allemp.first_name || ' ' || allemp.last_name || '.');
    END Loop;
    dbms_output.put_line('-----------------------------------');
    OPEN Emp FOR
    SELECT *
    FROM employees
	WHERE  salary >= 15000
	ORDER BY employee_id;
    Loop
        FETCH Emp into allemp;
        EXIT WHEN Emp%NOTFOUND;
        dbms_output.put_line('Employee with ID ' || allemp.employee_id ||
        ', his(her) first name is ' || allemp.first_name || ' and last name is ' ||
        allemp.last_name || ' with salary is' || to_char(allemp.salary, '$99,999') || '.');
    END Loop;
    CLOSE Emp;
END;
Output of Q5:
Employee with ID 105, his(her) full name is David Austin.
Employee with ID 104, his(her) full name is Bruce Ernst.
Employee with ID 103, his(her) full name is Alexander Hunold.
Employee with ID 107, his(her) full name is Diana Lorentz.
Employee with ID 106, his(her) full name is Valli Pataballa.
-----------------------------------
Employee with ID 100, his(her) first name is Steven and last name is King with salary is $24,000.
Employee with ID 101, his(her) first name is Neena and last name is Kochhar with salary is $17,000.
Employee with ID 102, his(her) first name is Lex and last name is De Haan with salary is $17,000.

    

        
    
    



    
    


