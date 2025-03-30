REM Q1.
DECLARE
    TYPE tab_column IS RECORD(
        col_name varchar2(30),
        data_type varchar2(30),
        data_len number
    );
    v1 tab_column;
    CURSOR c IS
    select column_name, data_type, data_length
    from user_tab_columns
    where upper(table_name)='LOCATIONS';
BEGIN
    dbms_output.put_line('Column Name     DataType    DataLength');
    dbms_output.put_line('------------    ---------    ----------');
    OPEN c;
    Loop
        FETCH c INTO v1;
        EXIT WHEN c%NOTFOUND;
        dbms_output.put_line(RPAD(v1.col_name, 17) || RPAD(v1.data_type, 18) ||
        v1.data_len);
    END Loop;
    CLOSE c;
END;
Output of Q1:
Column Name     DataType    DataLength
------------    ---------    ----------
LOCATION_ID      NUMBER            22
STREET_ADDRESS   VARCHAR2          40
POSTAL_CODE      VARCHAR2          12
CITY             VARCHAR2          30
STATE_PROVINCE   VARCHAR2          25
COUNTRY_ID       CHAR              2

REM Q2.
DECLARE
    TYPE DEPT_INFO IS RECORD(
        dept_id departments.department_id%TYPE,
        dept_name departments.department_name%TYPE,
        city varchar2(30),
        number_worker number
    );
    v1 DEPT_INFO;
BEGIN
    dbms_output.put_line('Department ID   Department Name      City           Number of employees');
    dbms_output.put_line('-----------       ------------     ---------         ------------------');
    select department_name 
    into v1.dept_name
    from departments
    where department_id=60;
    select l.city
    into v1.city
    from locations l
    join departments d
        on l.location_id=d.location_id
    where d.department_id=60;
    select department_id, count(*) as total_worker
    into v1.dept_id, v1.number_worker
    from employees
    where department_id=60
    group by department_id;
    dbms_output.put_line(RPAD(v1.dept_id, 22) || RPAD(v1.dept_name,14) ||
    RPAD(v1.city, 20) || ' ' ||v1.number_worker);
END;
Output of Q2:
Department ID   Department Name      City           Number of employees
-----------       ------------     ---------         ------------------
60                    IT            Southlake            5

REM Q3.
DECLARE
    TYPE Dept_Info IS RECORD(
        dept_id departments.department_id%TYPE,
        dept_name departments.department_name%TYPE,
        city varchar2(30)
        );
    TYPE Dept_Info_NT IS TABLE OF Dept_Info;
    LIST Dept_Info_NT:=Dept_Info_NT(); -- constructor
    CURSOR c1 IS 
    select department_id, department_name
    from departments
    where manager_id is not null;
    CURSOR c2 IS
    select l.city as cityname
    from locations l
    join departments d
        on l.location_id=d.location_id
    where d.manager_id is not null;
    counter integer :=1;
BEGIN
    for indx in c1 Loop
        LIST.extend;
        LIST(counter).dept_id :=indx.department_id;
        LIST(counter).dept_name :=indx.department_name;
        counter :=counter+1;
    END Loop;
    counter :=1; -- reset the counter to be 1
    for indx in c2 Loop
        LIST(counter).city :=indx.cityname;
        counter :=counter+1;
    END Loop;
    dbms_output.put_line('Department ID  Department Name     City');
    dbms_output.put_line('-------------  ---------------     --------');
    for indx in LIST.FIRST .. LIST.LAST Loop
        dbms_output.put_line(RPAD(LIST(indx).dept_id,16) || RPAD(LIST(indx).dept_name, 19)
        || LIST(indx).city);
    END Loop;
END;
Output of Q3:
Department ID  Department Name     City
-------------  ---------------     --------
10              Administration     Southlake
20              Marketing          San Francisco
30              Purchasing         Seattle
40              Human Resources    Seattle
50              Shipping           Seattle
60              IT                 Seattle
70              Public Relations   Seattle
80              Sales              Toronto
90              Executive          London
100             Finance            Oxford
110             Accounting         Munich

REM Q4.
DECLARE
    deptid integer :=30;
    v_min_salary number;
    v_max_salary number;
    procedure Dept_Emp_sal(
        Deptno IN departments.department_id%TYPE,
        max_sal OUT employees.salary%TYPE,
        min_sal OUT employees.salary%TYPE
    ) IS
    BEGIN
        select MAX(salary), MIN(salary)
        INTO max_sal, min_sal
        from employees
        where department_id=Deptno;
    END Dept_Emp_sal;
BEGIN
    Dept_Emp_sal(deptid, v_max_salary, v_min_salary);
    dbms_output.put_line('The minimal salary in this department ' || deptid || 
    ' is' || to_char(v_min_salary, '$99,999') || ';' || CHR(10) ||
    'The maximum salary is' || to_char(v_max_salary, '$99,999'));
END;
Output of Q4:
The minimal salary in this department 30 is  $2,500;
The maximum salary is $11,000

REM Q5.
CREATE OR REPLACE procedure Dept_Emp_sal(
        Deptno IN departments.department_id%TYPE,
        max_sal OUT employees.salary%TYPE,
        min_sal OUT employees.salary%TYPE
    ) IS
BEGIN
    select MAX(salary), MIN(salary)
    INTO max_sal, min_sal
    from employees
    where department_id=Deptno;
END;
/
DECLARE
    deptid integer :=30;
    v_min_salary number;
    v_max_salary number;
BEGIN
    Dept_Emp_sal(deptid, v_max_salary, v_min_salary);
    dbms_output.put_line('The minimal salary in this department ' || deptid || 
    ' is' || to_char(v_min_salary, '$99,999') || ';' || CHR(10) ||
    'The maximum salary is' || to_char(v_max_salary, '$99,999'));
END;
Output of Q5:
The minimal salary in this department 30 is  $2,500;
The maximum salary is $11,000

REM Q6.
DECLARE
    CURSOR c IS 
    select department_id
    from departments
    where manager_id is not null;
    deptid integer;
    v_min_salary number;
    v_max_salary number;
BEGIN
    OPEN c;
    Loop
        FETCH c INTO deptid;
        EXIT WHEN c%NOTFOUND;
        Dept_Emp_sal(deptid, v_max_salary, v_min_salary);
        dbms_output.put_line('The minimal salary in this department ' || deptid || 
        ' is' || to_char(v_min_salary, '$99,999') || ';' || CHR(10) ||
        'The maximum salary is' || to_char(v_max_salary, '$99,999'));
        dbms_output.put_line(' ');
    END Loop;
    CLOSE c;
END;
Output of Q6:
The minimal salary in this department 10 is  $4,400;
The maximum salary is  $4,400
 
The minimal salary in this department 20 is  $6,000;
The maximum salary is $13,000
 
The minimal salary in this department 30 is  $2,500;
The maximum salary is $11,000
 
The minimal salary in this department 40 is  $6,500;
The maximum salary is  $6,500
 
The minimal salary in this department 50 is  $2,100;
The maximum salary is  $8,200
 
The minimal salary in this department 60 is  $4,200;
The maximum salary is  $9,000
 
The minimal salary in this department 70 is $10,000;
The maximum salary is $10,000
 
The minimal salary in this department 80 is  $6,100;
The maximum salary is $14,000
 
The minimal salary in this department 90 is $17,000;
The maximum salary is $24,000
 
The minimal salary in this department 100 is  $6,900;
The maximum salary is $12,000
 
The minimal salary in this department 110 is  $8,300;
The maximum salary is $12,000
 