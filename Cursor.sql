REM Q1.
DECLARE
    emp_id employees.employee_id%TYPE :=311;
    emp_first_name employees.first_name%TYPE :='Fred';
    emp_last_name employees.last_name%TYPE :='Fritz';
    emp_salary employees.salary%TYPE :=5000;
BEGIN
    INSERT INTO Emp_60(employee_id, first_name, last_name, salary)
    VALUES(emp_id, emp_first_name, emp_last_name, emp_salary); 
    dbms_output.put_line('Employee with ID ' || emp_id || ', his first name is ' || 
    emp_first_name || '; his last name is ' || emp_last_name || ' and his salary is'|| 
    to_char(emp_salary, '$99,999') || '.');
END;
Output of Q1:
Employee with ID 311, his first name is Fred; his last name is Fritz and his salary is  $5,000.

REM Q2.
DECLARE
    emp_first_name employees.first_name%TYPE;
    emp_last_name employees.last_name%TYPE;
    new_salary employees.salary%TYPE;
BEGIN
    UPDATE Emp_60
    SET salary=6000
    WHERE employee_id=311
    RETURNING first_name, last_name, salary
    INTO emp_first_name, emp_last_name, new_salary;
    dbms_output.put_line('After update, his first name is ' || emp_first_name ||
    ', his last name is ' || emp_last_name || ' and his new salary is' || 
    to_char(new_salary, '$99,999') || '.');
END;
Output of Q2:
After update, his first name is Fred, his last name is Fritz and his new salary is  $6,000.

REM Q3.
DECLARE
    emp_id employees.employee_id%TYPE;
    emp_first_name employees.first_name%TYPE;
    emp_last_name employees.last_name%TYPE;
    emp_salary employees.salary%TYPE; 
BEGIN
    DELETE FROM Emp_60
    WHERE employee_id=311
    RETURNING employee_id, first_name, last_name, salary
    INTO emp_id, emp_first_name, emp_last_name, emp_salary;
    dbms_output.put_line('After deletion: the record deleted had employee ID = ' || emp_id
    || ', first name: ' || emp_first_name || ', last name: ' || emp_last_name || 
    chr(10) || 'and salary is'|| to_char(emp_salary, '$99,999') || '.');        
END;
Output of Q3:
After deletion: the record deleted had employee ID = 311, first name: Fred, last name: Fritz
and salary is  $6,000.

REM Q4.
DECLARE
    emp_id employees.employee_id%TYPE :=112;
    sal employees.salary%TYPE;
    hiring_date employees.hire_date%TYPE;
    work_year_bonus number :=0;
    salary_base_bonus number :=0;
    work_year number :=0;
    total_bonus number :=0;
BEGIN
    select salary, hire_date
    into sal, hiring_date
    from employees
    where employee_id=emp_id;
    work_year :=floor(months_between(to_date('31-12-24', 'DD-MM-YY'), hiring_date)/12);
    if work_year > 30 then
        work_year_bonus :=800;
    elsif 25 <= work_year AND work_year < 30 then
        work_year_bonus :=600;
    else
        work_year_bonus :=0;
    end if;
    if sal > 10000 then
        salary_base_bonus :=1300;
    elsif sal >= 5000 AND sal <= 10000 then
        salary_base_bonus :=1000;
    elsif sal < 5000 then
        salary_base_bonus :=800;
    end if;
    total_bonus :=work_year_bonus + salary_base_bonus;
    dbms_output.put_line('Employee with ID ' || emp_id ||
    ' has final amount of bonus equal to ' || to_char(total_bonus, '$99,999') || '.');
END;
Output of Q4:
Employee with ID 112 has final amount of bonus equal to   $1,600.

REM Q5.
BEGIN
    for i in 1 .. 9 Loop
        dbms_output.put('|');
        for j in 1 .. 9 Loop
            dbms_output.put(' '||i||j||' ');
        END Loop;
        dbms_output.put_line('|');
    END Loop;
END;

REM Q6.
BEGIN
    for n2 in 20 .. 24 Loop
        for n1 in 1 .. n2 Loop
            if MOD(n2,n1)=0 then
                dbms_output.put_line(n1 || ' is the factor of ' || n2 || '.');
            end if;
        END Loop;
        dbms_output.put_line('---------------');
    END Loop;
END;
Output of Q6:
1 is the factor of 20.
2 is the factor of 20.
4 is the factor of 20.
5 is the factor of 20.
10 is the factor of 20.
20 is the factor of 20.
---------------
1 is the factor of 21.
3 is the factor of 21.
7 is the factor of 21.
21 is the factor of 21.
---------------
1 is the factor of 22.
2 is the factor of 22.
11 is the factor of 22.
22 is the factor of 22.
---------------
1 is the factor of 23.
23 is the factor of 23.
---------------
1 is the factor of 24.
2 is the factor of 24.
3 is the factor of 24.
4 is the factor of 24.
6 is the factor of 24.
8 is the factor of 24.
12 is the factor of 24.
24 is the factor of 24.
---------------

REM Q7.
DECLARE
    sal Emp_60.salary%TYPE;
BEGIN
    UPDATE Emp_60
    SET salary=salary+(salary*0.05)
    WHERE salary <=6000;
    dbms_output.put_line('Number of row(s) affected = ' || to_char(SQL%ROWCOUNT));
    rollback;
END;
Output of Q7:
Number of row(s) affected = 4

REM Q8.
DECLARE
    CURSOR cname IS
    select * 
    from Emp_60
    where salary < 6000;
    record Emp_60%ROWTYPE;
BEGIN
    OPEN cname;
    Loop
        FETCH cname INTO record;
        EXIT WHEN cname%NOTFOUND;
        dbms_output.put_line('Employee with ID ' || record.employee_id ||
        ', his(her) full name is ' || record.last_name || ', ' || record.first_name ||
        ' with salary = ' ||to_char(record.salary, '$99,999') || '.');
    END Loop;
    CLOSE cname;
END;
Output of Q8:
Employee with ID 105, his(her) full name is Austin, David with salary =   $4,800.
Employee with ID 106, his(her) full name is Pataballa, Valli with salary =   $4,800.
Employee with ID 107, his(her) full name is Lorentz, Diana with salary =   $4,200.


