-- File PLh20.sql
-- Author: <<< Alexander Vansteel >>>
-------------------------------------------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF
------------------------------------
ACCEPT rateDecrement NUMBER PROMPT 'Enter the rate decrement: '
ACCEPT allowedMinRate NUMBER PROMPT 'Enter the allowed min. rate: '
DECLARE
	br	boats%ROWTYPE;
	CURSOR	bCURSOR IS
			SELECT b.bid, b.bname, b.color, b.rate, b.length, b.logkeeper 
			FROM boats b
			WHERE b.bid NOT IN (SELECT r.bid
					    FROM reservations r
					    WHERE r.bid = b.bid);
			
BEGIN
	OPEN bCURSOR;
	LOOP
		-- fetch the qualifying rows one by one
		FETCH bCURSOR INTO br;
		EXIT WHEN bCURSOR%NOTFOUND;
		-- print old rate
		DBMS_OUTPUT.PUT_LINE('+++++ Boat: ' ||br.bid|| ': old rate = ' ||br.rate);
		br.rate := br.rate - &rateDecrement;
		
		-- A nested block
		DECLARE
			belowAllowedMin EXCEPTION;
		BEGIN
			IF	br.rate < &allowedMinRate
			THEN	RAISE belowAllowedMin;
			ELSE 	UPDATE 	boats
				SET 	rate = br.rate
				WHERE	boats.bid = br.bid;
				-- Print new rate
				DBMS_OUTPUT.PUT_LINE('---- Boat: ' ||br.bid|| ': new rate: ' ||br.rate);
			END IF;
			
		EXCEPTION
			WHEN belowAllowedMin THEN
				DBMS_OUTPUT.PUT_LINE('----- Update rejected. The new rate would have been '
					 ||br.rate);
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('----- update rejected: ' ||SQLCODE|| '...' ||SQLERRM);
		END;
		-- end of the nested block
END LOOP;
	
	COMMIT;
	CLOSE bCURSOR;
END;
/ 
