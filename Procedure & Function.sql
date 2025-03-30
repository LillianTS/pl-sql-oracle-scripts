REM Q1(a).
DECLARE
    v_empid employees.employee_id%TYPE;
    v_sal employees.salary%TYPE;
    v_workyear number :=0;
    v_bonus number :=0;
    total_bonus number :=0;
    assigned_date DATE :='31-DEC-24';
    CURSOR c IS
    select employee_id
    from employees
    where department_id=60;
    procedure Emp_Bonus(
        emp_no IN number,
        Sal OUT number,
        work_year OUT integer,
        bonus OUT number
        ) IS 
    BEGIN
        select salary, floor(months_between(assigned_date, hire_date)/12)
        into Sal, work_year
        from employees
        where employee_id=emp_no;
        if work_year >= 30 then
            if Sal >= 8000 then
                bonus :=2500;
            elsif Sal >= 3000 then
                bonus :=2300;
            else
                bonus :=2000;
            end if;
        elsif work_year >= 26 then
            if Sal >= 8000 then
                bonus :=2000;
            elsif Sal >= 3000 then
                bonus :=1800;
            else
                bonus :=1500;
            end if;
        elsif work_year >= 23 then
            if Sal >= 8000 then
                bonus :=1800;
            elsif Sal >= 3000 then
                bonus :=1500;
            else
                bonus :=1200;
            end if;
        else
            bonus :=1000;
        end if;
    END Emp_bonus;
BEGIN
    dbms_output.put_line('ID   Current_Salary   Work_year     Bonus');
    dbms_output.put_line('---  --------------   ---------     -------');
    OPEN c;
    Loop
        FETCH c INTO v_empid;
        EXIT WHEN c%NOTFOUND;
        Emp_bonus(v_empid, v_sal, v_workyear, v_bonus);
        dbms_output.put_line(RPAD(v_empid, 9) || RPAD(to_char(v_sal, '$99,999'),15) ||
        RPAD(v_workyear, 10) || to_char(v_bonus, '$99,999'));
        total_bonus :=total_bonus+v_bonus;
    END Loop;
    CLOSE c;
    dbms_output.put_line(' ');
    dbms_output.put_line('Total bonus for department 60:' ||
    to_char(total_bonus, '$99,999'));
END;
Output of Q1(a):
ID   Current_Salary   Work_year     Bonus
---  --------------   ---------     -------
103        $9,000       34          $2,500
104        $6,000       33          $2,300
105        $4,800       27          $1,800
106        $4,800       26          $1,800
107        $4,200       25          $1,500
 
Total bonus for department 60:  $9,900

REM Q1(b).
CREATE OR REPLACE procedure Emp_Bonus(
    emp_no IN number,
    Sal OUT number,
    work_year OUT integer,
    bonus OUT number
        ) IS 
        assigned_date DATE :='31-DEC-24';  --local declaration
    BEGIN
        select salary, floor(months_between(assigned_date, hire_date)/12)
        into Sal, work_year
        from employees
        where employee_id=emp_no;
        if work_year >= 30 then
            if Sal >= 8000 then
                bonus :=2500;
            elsif Sal >= 3000 then
                bonus :=2300;
            else
                bonus :=2000;
            end if;
        elsif work_year >= 26 then
            if Sal >= 8000 then
                bonus :=2000;
            elsif Sal >= 3000 then
                bonus :=1800;
            else
                bonus :=1500;
            end if;
        elsif work_year >= 23 then
            if Sal >= 8000 then
                bonus :=1800;
            elsif Sal >= 3000 then
                bonus :=1500;
            else
                bonus :=1200;
            end if;
        else
            bonus :=1000;
        end if;
END;
/
DECLARE
    v_empid employees.employee_id%TYPE;
    v_sal employees.salary%TYPE;
    v_workyear number :=0;
    v_bonus number :=0;
    total_bonus number :=0;
    CURSOR c IS
    select employee_id
    from employees
    where department_id=60;
BEGIN
    dbms_output.put_line('ID   Current_Salary   Work_year     Bonus');
    dbms_output.put_line('---  --------------   ---------     -------');
    OPEN c;
    Loop
        FETCH c INTO v_empid;
        EXIT WHEN c%NOTFOUND;
        Emp_Bonus(v_empid, v_sal, v_workyear, v_bonus);
        dbms_output.put_line(RPAD(v_empid, 9) || RPAD(to_char(v_sal, '$99,999'),15) ||
        RPAD(v_workyear, 10) || to_char(v_bonus, '$99,999'));
        total_bonus :=total_bonus+v_bonus;
    END Loop;
    CLOSE c;
    dbms_output.put_line(' ');
    dbms_output.put_line('Total bonus for department 60:' ||
    to_char(total_bonus, '$99,999'));
END;
Output of Q1(b):
ID   Current_Salary   Work_year     Bonus
---  --------------   ---------     -------
103        $9,000       34          $2,500
104        $6,000       33          $2,300
105        $4,800       27          $1,800
106        $4,800       26          $1,800
107        $4,200       25          $1,500
 
Total bonus for department 60:  $9,900

REM Q1(c).
CREATE OR REPLACE FUNCTION F_Bonus(
    empno IN number)
    return number
    IS
    sal number;
    bonus number :=0;
    work_year number :=0;
    assigned_date DATE :='31-DEC-24';
BEGIN
    select salary, floor(months_between(assigned_date, hire_date)/12)
    into sal, work_year
    from employees
    where employee_id=empno;
    if work_year >= 30 then
        if sal >= 8000 then
            bonus :=2500;
        elsif sal >= 3000 then
            bonus :=2300;
        else
            bonus :=2000;
        end if;
        elsif work_year >= 26 then
            if sal >= 8000 then
                bonus :=2000;
            elsif sal >= 3000 then
                bonus :=1800;
            else
                bonus :=1500;
            end if;
        elsif work_year >= 23 then
            if sal >= 8000 then
                bonus :=1800;
            elsif sal >= 3000 then
                bonus :=1500;
            else
                bonus :=1200;
            end if;
        else
            bonus :=1000;
    end if;
    return bonus;
END;
/
DECLARE
    CURSOR c IS
    select employee_id
    from employees
    where department_id=60;
    v_empid employees.employee_id%TYPE;
    v_bonus number;
BEGIN
    dbms_output.put_line('ID     Bonus');
    dbms_output.put_line('---    -------');
    OPEN c;
    Loop
        FETCH c INTO v_empid;
        EXIT WHEN c%NOTFOUND;
        v_bonus :=F_Bonus(v_empid);
        dbms_output.put_line(RPAD(v_empid, 5) || 
        to_char(v_bonus , '$99,999'));
    END Loop;
    CLOSE c;
END;
Output of Q1(c):
ID     Bonus
---    -------
103    $2,500
104    $2,300
105    $1,800
106    $1,800
107    $1,500

REM Q1(d).
DECLARE
    TYPE E_Bonus IS RECORD(
        emp_ID number (6),                  
        emp_Sal number (8, 2),             
        emp_Tenure number (2),           
        emp_Bonus number (6) 
    );
    v E_Bonus; --record variable name
    CURSOR c IS
    select employee_id
    from employees
    where department_id=60;
    total_bonus number:=0;
    FUNCTION Fn_Bonus(
        emp_id IN number)
        return E_Bonus
        IS
        assigned_date DATE :='31-DEC-24';
        R E_Bonus;
    BEGIN
        select employee_id, salary, floor(months_between(assigned_date, hire_date)/12)
        into R.emp_ID, R.emp_Sal, R.emp_Tenure
        from employees
        where employee_id=emp_id;
        if R.emp_Tenure >= 30 then
            if R.emp_Sal >= 8000 then
                R.emp_Bonus :=2500;
            elsif R.emp_Sal >= 3000 then
                R.emp_Bonus :=2300;
            else
                R.emp_Bonus :=2000;
            end if;
        elsif R.emp_Tenure >= 26 then
            if R.emp_Sal >= 8000 then
                R.emp_Bonus :=2000;
            elsif R.emp_Sal >= 3000 then
                R.emp_Bonus :=1800;
            else
                R.emp_Bonus :=1500;
            end if;
        elsif R.emp_Tenure >= 23 then
            if R.emp_Sal >= 8000 then
                R.emp_Bonus :=1800;
            elsif R.emp_Sal >= 3000 then
                R.emp_Bonus :=1500;
            else
                R.emp_Bonus :=1200;
            end if;
        else
            R.emp_Bonus :=1000;
        end if;
        return R;
    END Fn_Bonus;
BEGIN
    dbms_output.put_line('ID   Current_Salary   Work_year     Bonus');
    dbms_output.put_line('---  --------------   ---------     -------');
    for indx in c Loop
        v :=Fn_Bonus(indx.employee_id);
        dbms_output.put_line(RPAD(v.emp_ID, 9) || RPAD(to_char(v.emp_Sal, '$99,999'),15) ||
        RPAD(v.emp_Tenure, 10) || to_char(v.emp_Bonus, '$99,999'));
        total_bonus :=total_bonus+v.emp_Bonus;
    END Loop;
    dbms_output.put_line(' ');
    dbms_output.put_line('Total bonus for department 60:' ||
    to_char(total_bonus, '$99,999'));
END;
Output of Q1(d):
ID   Current_Salary   Work_year     Bonus
---  --------------   ---------     -------
103        $9,000       34          $2,500
104        $6,000       33          $2,300
105        $4,800       27          $1,800
106        $4,800       26          $1,800
107        $4,200       25          $1,500
 
Total bonus for department 60:  $9,900

REM Q2.
DECLARE
    deptno number :=60;
    deptname varchar2(25) :='IT';
    fulladdress varchar2(255);
    FUNCTION Dept_Address(
        Dept_ID IN number)
        return varchar2
        IS 
        full_address varchar2(255);
    BEGIN
        select l.street_address || ' ' || l.city || ', ' ||
        l.state_province || ' ' || l.Postal_code || ', ' || ' ' || l.country_id as Address
        into full_address
        from Locations l
        join departments d
            on l.location_id=d.location_id
        where department_id=Dept_ID;
        return full_address;
    END Dept_Address;
    FUNCTION Dept_Address(
        dept_name IN varchar2)
        return varchar2
        IS
        full_address varchar2(255);
    BEGIN
        select l.street_address || ' ' || l.city || ', ' ||
        l.state_province || ' ' || l.Postal_code || ', ' || ' ' || l.country_id as Address
        into full_address
        from Locations l
        join departments d
            on l.location_id=d.location_id
        where department_name=dept_name;
        return full_address;
    END Dept_Address;
BEGIN
    fulladdress :=Dept_Address(deptno);
    dbms_output.put_line('Department ID ' || deptno ||
    ' ,its address is:' || chr(10) || fulladdress || chr(10));
    fulladdress :=Dept_Address(deptname);
    dbms_output.put_line('Department Name ' || deptname ||
    ' ,its address is:' || chr(10) || fulladdress);
END;
Output of Q2:
Department ID 60 ,its address is:
2014 Jabberwocky Rd Southlake, Texas 26192,  US

Department Name IT ,its address is:
2014 Jabberwocky Rd Southlake, Texas 26192,  US

REM Q3.
DECLARE
    TYPE emp_name IS RECORD (
        f_name VARCHAR2(20),
        l_name VARCHAR2(25)
    );
    emp1 emp_name;  --record variable name
    emp2 emp_name;  --record variable name
    emp3 emp_name;  --record variable name
    FUNCTION Emp_name_eq(
        rec1 IN emp_name, 
        rec2 IN emp_name) 
        return boolean 
        IS
        ret boolean;
    BEGIN
        IF UPPER(rec1.f_name) = UPPER(rec2.f_name) AND 
        UPPER(rec1.l_name) = UPPER(rec2.l_name) THEN
            ret := true;
        ELSE
            ret :=false;
        END IF;
        return ret;
    END Emp_name_eq;
BEGIN
    select first_name, last_name 
    into emp1 
    from employees 
    where employee_id = 200;
    emp2 := emp1;
    emp3.f_name := 'JENIFER';
    emp3.l_name := 'WHALEN';
    IF emp_name_eq (emp1, emp2) THEN
        DBMS_OUTPUT.PUT_LINE('The two records emp1 '''|| emp1.f_name || 
        ' ' || emp1.l_name ||''' and emp2 '''|| emp2.f_name || ' ' || 
        emp2.l_name || ''' are the same.' );
    ELSE
        DBMS_OUTPUT.PUT_LINE('The two records emp1 '''|| emp1.f_name || 
        ' ' || emp1.l_name ||''' and emp2 '''|| emp2.f_name || ' ' || 
        emp2.l_name || ''' are Not same.' );
    END IF;
    IF emp_name_eq (emp2, emp3) THEN
        DBMS_OUTPUT.PUT_LINE('The two records emp2 '''|| emp2.f_name || 
        ' ' || emp2.l_name ||''' and emp3 '''|| emp3.f_name || ' ' || 
        emp3.l_name || ''' are the same.' );
    ELSE
        DBMS_OUTPUT.PUT_LINE('The two records emp2 '''|| emp2.f_name || 
        ' ' || emp2.l_name ||''' and emp3 '''|| emp3.f_name || ' ' || 
        emp3.l_name || ''' are Not same.' );
   END IF;
END;
Output of Q3:
The two records emp1 'Jennifer Whalen' and emp2 'Jennifer Whalen' are the same.
The two records emp2 'Jennifer Whalen' and emp3 'JENIFER WHALEN' are Not same.



