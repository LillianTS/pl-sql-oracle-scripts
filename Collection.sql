set serveroutput on 
  -- you only need to run this command one time for a session (one log in)

REM Q1. 
DECLARE
	TYPE Letter_AA IS TABLE OF Char(1)  
	INDEX BY Binary_Integer;
   	v_aa 	Letter_AA;
	x       char(1)  := 'A' ;
BEGIN
   	FOR indx IN 1 .. 6  LOOP
      	v_aa (indx) := x;
      	DBMS_OUTPUT.PUT_LINE ( indx ||': ' ||
 			v_aa (indx));   	
	x := CHR( ASCII(x) +1) ;
	END LOOP;
END;
/
1: A
2: B
3: C
4: D
5: E
6: F

REM Q1B
DECLARE
	TYPE Letter_AA IS TABLE OF Char(1)  
	INDEX BY Binary_Integer;
   	v_aa 	Letter_AA;
BEGIN
    v_aa (1) := 'A' ;
	v_aa (2) := 'B' ;
	v_aa (3) := 'C' ;
	v_aa (4) := 'D' ;
	v_aa (5) := 'E' ;
	v_aa (6) := 'F' ;
	FOR indx IN 1 .. 6  LOOP
      	   DBMS_OUTPUT.PUT_LINE ( indx ||': ' ||  v_aa (indx));   	
	END LOOP;
END;


REM Q2_A.
 
DECLARE
	TYPE Lname_Sal IS TABLE OF employees.salary%TYPE 
	INDEX BY varchar2(25);
   	v1 	 Lname_Sal;
	i 	 varchar2(25); 
    counter  integer := 1;
   	
        CURSOR  c IS
      	SELECT 	last_name, salary
        FROM    employees
        Where   department_id = 50;  -- "and rownum <= 12", then no need counter later
        
BEGIN
    DBMS_OUTPUT.PUT_LINE (' - - In order of populating - -   '|| CHR (10));
    DBMS_OUTPUT.PUT_LINE (' Last Name      Salary  ');
    DBMS_OUTPUT.PUT_LINE ('------------ ------------');
    
    FOR indx IN c LOOP
       v1 (indx.last_name) := indx.salary;
      	 
       DBMS_OUTPUT.PUT_LINE (RPAD (indx.last_name, 12) ||'  ' ||
 			To_char (v1 (indx.last_name), '$99,999'));    	
       counter := counter + 1 ;
       Exit when counter > 12;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE ('  ');
    DBMS_OUTPUT.PUT_LINE (' In order of Last_name  '|| CHR (10));
    DBMS_OUTPUT.PUT_LINE ('No   Last Name      Salary  ');
    DBMS_OUTPUT.PUT_LINE ('--- ------------ ------------');
    
    i := v1.FIRST; 	-- Get first element of array
    counter := 1;

    WHILE i IS NOT NULL LOOP
	DBMS_OUTPUT.PUT_LINE ( RPAD (counter, 4) || RPAD (i, 12) ||'  ' ||
 			To_char (v1 (i), '$99,999'));    	
	i := v1.NEXT(i); 	-- Get next element of array
	counter := counter + 1 ;
    END LOOP;
END;
/
OUTPUT
- - In order of populating - -   

 Last Name      Salary  
------------ ------------
Weiss           $8,000
Fripp           $8,200
Kaufling        $7,900
Vollman         $6,500
Mourgos         $5,800
Nayer           $3,200
Mikkilineni     $2,700
Landry          $2,400
Markle          $2,200
Bissot          $3,300
Atkinson        $2,800
Marlow          $2,500
  
 In order of Last_name  

No   Last Name      Salary  
--- ------------ ------------
1   Atkinson        $2,800
2   Bissot          $3,300
3   Fripp           $8,200
4   Kaufling        $7,900
5   Landry          $2,400
6   Markle          $2,200
7   Marlow          $2,500
8   Mikkilineni     $2,700
9   Mourgos         $5,800
10  Nayer           $3,200
11  Vollman         $6,500
12  Weiss           $8,000

-- Q2 B

DECLARE
	TYPE Lname_Sal IS TABLE OF employees.salary%TYPE 
	INDEX BY varchar2(25);
   	v1 	 Lname_Sal;
	i 	 varchar2(25); 
        counter  integer := 1;
   	
        CURSOR  c IS
      	SELECT 	last_name, salary
        FROM    employees
        Where   department_id = 50 and rownum <= 12 ;
        
BEGIN
    DBMS_OUTPUT.PUT_LINE (' - - In order of populating - -   '|| CHR (10));
    DBMS_OUTPUT.PUT_LINE (' Last Name      Salary  ');
    DBMS_OUTPUT.PUT_LINE ('------------ ------------');
    
    FOR indx IN c LOOP
       v1 (indx.last_name) := indx.salary;
      	 
       DBMS_OUTPUT.PUT_LINE (RPAD (indx.last_name, 12) ||'  ' ||
 			To_char (v1 (indx.last_name), '$99,999'));    	
            END LOOP;

    DBMS_OUTPUT.PUT_LINE ( CHR (10)|| ' In order of Last_name  '|| CHR (10));
    DBMS_OUTPUT.PUT_LINE ('No   Last Name      Salary  ');
    DBMS_OUTPUT.PUT_LINE ('--- ------------ ------------');
    
    i := v1.FIRST; 	-- Get first element of array
    
    WHILE i IS NOT NULL LOOP
	DBMS_OUTPUT.PUT_LINE ( RPAD (counter, 4) || RPAD (i, 12) ||'  ' ||
 			To_char (v1 (i), '$99,999'));    	
	i := v1.NEXT(i); 	-- Get next element of array
	END LOOP;
END;
/

REM Q3.
DECLARE
    TYPE Lname IS Varray (15) OF employees.last_name%TYPE ;
    v1   Lname := lname ();
    counter  integer := 1;
 	
    CURSOR c IS
      	SELECT 	last_name
        FROM    employees
        Where   department_id = 50
        order by employee_id ;
 
BEGIN
    DBMS_OUTPUT.PUT_LINE ('No    Last Name   ');
    DBMS_OUTPUT.PUT_LINE ('---- -------------');
    FOR indx IN c LOOP
       v1.extend;
       v1 (counter) := indx.last_name;
      	 
       DBMS_OUTPUT.PUT_LINE (RPAD (counter, 6)|| v1 (counter));
       counter := counter + 1 ;
       Exit when counter > 12;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ( ' ');
    DBMS_OUTPUT.PUT_LINE('Q2. The maxium size (v1.limit): '|| v1.limit );
    DBMS_OUTPUT.PUT_LINE('Q3. The last index value (v1.last) is: '|| v1.last );
    
    DBMS_OUTPUT.PUT_LINE ( ' ');
    DBMS_OUTPUT.PUT_LINE ('Q4. After added two new elements to the Varay: ');
    v1.extend(2);
    counter := 13 ;
    v1(counter)  := 'Washington' ;
    DBMS_OUTPUT.PUT_LINE ('   -- New added element: '||RPAD (counter, 4) || v1 (counter) );
    counter := counter +1 ;
    v1(counter)  := 'Lincoln' ;
    DBMS_OUTPUT.PUT_LINE ('   -- New added element: '||RPAD (counter, 4) || v1 (counter) );
    DBMS_OUTPUT.PUT_LINE(CHR (10)|| 'Q5_a. The current maximum size (v1.limit) =  '|| v1.limit );
    DBMS_OUTPUT.PUT_LINE('Q5_b. The last index value (v1.last) now is : '|| v1.last );
    
    DBMS_OUTPUT.PUT_LINE ( ' ');
    DBMS_OUTPUT.PUT_LINE ('Q6. Now we delete all the elements in the varray: ');
    v1.delete ;
    DBMS_OUTPUT.PUT_LINE('Q7_a. Afrer the deletion, the maximum size: '|| v1.limit );
    IF v1.last is null THEN
      DBMS_OUTPUT.PUT_LINE('Q7_b. After the deletion, the last index value is null;' );
    ELSE
      DBMS_OUTPUT.PUT_LINE('Q7_b. Varray last index value: '|| v1.last );
    END IF;
END;
/

OUTPUT
No    Last Name   
---- -------------
1     Weiss
2     Fripp
3     Kaufling
4     Vollman
5     Mourgos
6     Nayer
7     Mikkilineni
8     Landry
9     Markle
10    Bissot
11    Atkinson
12    Marlow
 
Q2. The maxium size (v1.limit): 15
Q3. The last index value (v1.last) is: 12
 
Q4. After added two new elements to the Varay: 
   -- New added element: 13  Washington
   -- New added element: 14  Lincoln

Q5_a. The current maximum size (v1.limit) =  15
Q5_b. The last index value (v1.last) now is : 14
 
Q6. Now we delete all the elements in the varray: 
Q7_a. Afrer the deletion, the maximum size: 15
Q7_b. After the deletion, the last index value is null;


PL/SQL procedure successfully completed.

REM Q4.
-- change: Varray (15) - > TABLE

DECLARE
    TYPE Lname IS Table OF employees.last_name%TYPE ;
    v1   Lname := lname ();
    counter  integer := 1;
 	
    CURSOR c IS
      	SELECT 	last_name
        FROM    employees
        Where   department_id = 50
        order by employee_id ;
 
BEGIN
    DBMS_OUTPUT.PUT_LINE ('No    Last Name   ');
    DBMS_OUTPUT.PUT_LINE ('---- -------------');
    FOR indx IN c LOOP
       v1.extend;
       v1 (counter) := indx.last_name;
      	 
       DBMS_OUTPUT.PUT_LINE (RPAD (counter, 6)|| v1 (counter));
       counter := counter + 1 ;
       Exit when counter > 12;
    END LOOP;
    
    IF v1.limit is null THEN
       DBMS_OUTPUT.PUT_LINE( CHR(10)|| 'Q2. For type NT, there is no Limit, ' 
                 || 'the output of v1.limit is null;');
    ELSE
       DBMS_OUTPUT.PUT_LINE( CHR(10)|| 'Q2. NT max size: '|| v1.limit);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE( CHR(10)|| 'Q3. The current last index value is: '|| v1.last);

    v1.extend(2);
    counter := 13 ;
    v1(counter)  := 'Washington' ;
        counter := counter +1 ;
    v1(counter)  := 'Lincoln' ;
    
    DBMS_OUTPUT.PUT_LINE ( CHR(10)||'Q5. After added two new elements, the NT list as below:' );
    
    DBMS_OUTPUT.PUT_LINE ('No    Last Name   ');
    DBMS_OUTPUT.PUT_LINE ('---- -------------'); 
   FOR i in v1.first .. v1.last loop
      DBMS_OUTPUT.PUT_LINE (RPAD (i, 6)|| v1 (i));
    END loop;
   
    DBMS_OUTPUT.PUT_LINE(CHR (10) ||'Q6_a. After adding, current size is: ' || v1.count );
    DBMS_OUTPUT.PUT_LINE(CHR (10) ||'Q6_b. The curent last index value is: '|| v1.last );
    
    v1.delete (5, 7) ;
    DBMS_OUTPUT.PUT_LINE ( ' ');
    DBMS_OUTPUT.PUT_LINE (CHR (10) ||'Q8_a. After deleting elements 5-7, the current size: '||
                           v1.count );
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Q8_b. The last index value is: '|| v1.last );
       
   DBMS_OUTPUT.PUT_LINE ( CHR(10)||'Q9. After deletion, the NT list as below:' );
    
    DBMS_OUTPUT.PUT_LINE ('No    Last Name   ');
    DBMS_OUTPUT.PUT_LINE ('---- -------------');  
   counter := v1.first ;
    
   While counter is not null loop
      DBMS_OUTPUT.PUT_LINE (RPAD (counter, 6)|| v1 (counter));
      counter := v1.next (counter) ;
    END loop;
END;
/

OUTPUT
No    Last Name   
---- -------------
1     Weiss
2     Fripp
3     Kaufling
4     Vollman
5     Mourgos
6     Nayer
7     Mikkilineni
8     Landry
9     Markle
10    Bissot
11    Atkinson
12    Marlow

Q2. For type NT, there is no Limit, the output of v1.limit is null;

Q3. The current last index value is: 12

Q5. After added two new elements, the NT list as below:
No    Last Name   
---- -------------
1     Weiss
2     Fripp
3     Kaufling
4     Vollman
5     Mourgos
6     Nayer
7     Mikkilineni
8     Landry
9     Markle
10    Bissot
11    Atkinson
12    Marlow
13    Washington
14    Lincoln

Q6_a. After adding, current size is: 14

Q6_b. The curent last index value is: 14
 

Q8_a. After deleting elements 5-7, the current size: 11

Q8_b. The last index value is: 14

Q9. After deletion, the NT list as below:
No    Last Name   
---- -------------
1     Weiss
2     Fripp
3     Kaufling
4     Vollman
8     Landry
9     Markle
10    Bissot
11    Atkinson
12    Marlow
13    Washington
14    Lincoln

REM Q5
-- change: ADD "INDEX BY PLS_INTEGER";  no construct, no extend.

DECLARE
    TYPE Lname IS Table OF employees.last_name%TYPE 
    index by PLS_INTEGER;     -- add thie index by
    v1   Lname ;              -- no construct comapring to NT
    counter  integer := 1;
 	
    CURSOR c IS
      	SELECT 	last_name
        FROM    employees
        Where   department_id = 50
        order by employee_id ;
BEGIN
    DBMS_OUTPUT.PUT_LINE ('No    Last Name   ');
    DBMS_OUTPUT.PUT_LINE ('---- -------------'); 
    FOR indx IN c LOOP
       v1 (counter) := indx.last_name;
      	 
       DBMS_OUTPUT.PUT_LINE (RPAD (counter, 6)  ||
               v1 (counter)  );
       counter := counter + 1 ;
       Exit when counter > 12;
    END LOOP;
END;
/


REM Q6.

DECLARE
   TYPE NT1 IS TABLE  OF INTEGER;  -- NT of integer
   X1 NT1 := NT1(1, 2, 3);
   X2 NT1 := NT1(4, 5, 6);
   X3 NT1 := NT1(7, 8, 9);
   
   TYPE NTNT1 IS TABLE OF NT1;    -- NT of NT
   NY1  NTNT1 := NTNT1 (X1, X2, X3);
   
BEGIN

  DBMS_OUTPUT.PUT_LINE('Q3. The value of 2nd element''s 3rd element NY1 (2)(3): ' ||
               NY1 (2)(3) );

  NY1.EXTEND;			 -- add one more element. index = 4
  NY1(4) := NT1 (11,22,33,44,55,66);  -- Assign values to element #4
  DBMS_OUTPUT.PUT_LINE('Q5. The value of 3rd element of NY1(4) is ' || NY1 (4)(3));

END;
/ 
OUTPUT
Q3. The value of 2nd element's 3rd element NY1 (2)(3): 6
Q5. The value of 3rd element of NY1(4) is 33
