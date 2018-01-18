-- ***************************************************************************************
-- * PROJECT: LW6 - Security Alarm Control Panel
-- * FILENAME: lw6.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * PROVIDES: 
-- * - This specification describes and defines the basic requirements of the CE1911 
-- *   security alarm control panel. The control panel is used to provide security on 
-- *   a door.  
-- * FUNCTIONS: 
-- *   1. The system must recognize the code used to arm the security alarm. 
-- *   2. The system must recognize the code used to disarm the security alarm.
-- *   3. The system must provide visual feedback to the user as code entry keys are 
-- *      pressed
-- *   4. The system must provide audible feedback to the user if an incorrect code is 
-- *      entered. 
-- *   5. The system must operate from standard line power or USB supplied power.
-- * USE-CASE EVENTS:
-- *   1. Reset Event 
-- *       A. The user resets the system.  
-- *       B. The system identifies the reset request.
-- *  	  C. The system resets the system. 
-- *   2. Button Event 
-- *	     A. The user presses a control panel key.  
-- *       B. The system identifies the key.  
-- *       C. The system updates the stored code.
-- *       D. The system updates the user display.
-- *   3. Lock Event
-- *       A. The system identifies the lock code.  
-- *       B. The system updates the user display.  
-- *       C. The system locks the door.  
-- *   4. Unlock Event
-- *       A. The system identifies the unlock code.  
-- *       B. The system updates the user display.
-- *       C. The system unlocks the door.
-- *   5. Err Event
-- *       A. The system identifies an incorrect code (err).
-- *       B. The system updates the user display.  
-- *       C. The system turns on an alarm to alert nearby personnel. 
-- ***************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: rising_edge
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration: external-view
-- inputs: 
--    CLK: register sample clock
--    CLR: Synchronous register clear
--          i)  Digital slide switch to request system reset
--          ii)  Active when low
--          iii) Sychronizes to the rising edge of the clock
--    AB:  A bus of two digital pushbuttons to allow code entry; produce logic-0 when 
--         pressed 
-- outputs: 
-- 	A. The system creates a digital output called L. 
--        i)   Output L connects to the lock mechanism.  
--        ii)  Output L connects also connects to a status LED. 
--        iii) The lock mechanism and LED are active when high (logic-1 = locked).   
--  	B. The system creates 48 digital output signals that drive the LED segments of five
--       7-segment displays. 
--        i)   The output signals are divided into six 8-bit busses called hex0, hex1, 
--             hex2, hex3, hex4, and hex5. 
--        ii)  The system generates status text unlock, lock, ok, err on the display. 
--        iii) The "unlock" status text represents an unlocked door.  
--        iv)  The "lock" status text represents a locked door.  
--        v)   The "ok" status text represents the last button press is part of a lock 
--             or unlock code.  
--        vi)  The "err" status text represents an incorrect code has been entered. 
--   C. The system creates a digital output called Alarm.  
--        i)   The output connects to a pulsed sonic-alert.  
--        ii)  The sonic-alert is active when high (logic-1 = make alarm sound).  
--        iii) The sonic alert sounds when an incorrect code has been entered. 
-- functional specification
--    The system is a Moore finite state machine.  
--    1. The machine enters the reset state when the active-low CLR slide switch asserts. 
--    2. The system enters appropriate states based on the values of pushbutton inputs A 
--       and B. 
--    3. Pushbutton inputs “00” and “11” cause the machine to remain in the current state.  
--    4. The lock code is ABAABB.  
--    5. The unlock code is BBBABA. 
--    6. The machine enters the error state if an incorrect code is entered.  
--    7. The machine enters the locked state if the lock code is correctly entered.  
--    8. The machine enters the unlocked state if the unlock code is correctly entered 
--       after the system is locked. 
entity lw6 is
port(CLK  : in  std_logic;
	  CLR  : in  std_logic;
	  AB   : in  std_logic_vector(1 downto 0);
	  L    : out std_logic;
	  ALARM: out std_logic;	
	  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5: out std_logic_vector(7 downto 0)
	  );
end entity lw6;

-- architecture: internal circuit 
-- signals: 
--   D: Moore FSM next state 
--   Q: Moore FSM current state 
architecture behavioral of lw6 is 
   -- 13 total states
	type states is (-- reset state/ unlock state (fBBBABA)     
	                UNLOCK,
						 -- state for wrong code entered
						 ERR,
						 -- states to reach locked state
						 fA, fAB,fABA,fABAA,fABAAB, 
					    -- locked state (fABAABB)
						 LOCK,
						 -- states to reach unlocked state 
						 fB,fBB,fBBB,fBBBA,fBBBAB
						 );
						 
	signal D, Q: states;
	-- add these signal declarations in the architecture signal section 
	signal cnt: integer range 0 to 12500000; 
	signal clk1Hz: std_logic; 
 
 begin 
 
	-- next state logic
	-- any state moves to UNLOCK if CLR switch is flipped 
	D 	<= fA     when Q=UNLOCK and AB="01" else 
			fB	    when	Q=LOCK	and AB="10"	else
			UNLOCK when Q=UNLOCK	and AB="00"	else
			UNLOCK when Q=UNLOCK	and AB="11"	else
			
			ERR	 when	Q=fA	   and AB="01"	else
			fAB	 when	Q=fA	   and AB="10"	else
			fA     when Q=fA	   and AB="00"	else
			fA     when Q=fA	   and AB="11"	else
			
			ERR	 when	Q=fB	   and AB="01"	else
			fBB	 when	Q=fB	   and AB="10"	else
			fB 	 when	Q=fB	   and AB="00"	else
			fB 	 when	Q=fB	   and AB="11"	else

			fABA	 when	Q=fAB	   and AB="01"	else
			ERR	 when	Q=fAB	   and AB="10"	else
			fAB    when Q=fAB    and AB="00"	else
			fAB    when Q=fAB    and AB="11"	else
			
			ERR	 when	Q=fBB	   and AB="01"	else
			fBBB	 when	Q=fBB	   and AB="10"	else
			fBB 	 when	Q=fBB	   and AB="00"	else
			fBB 	 when	Q=fBB	   and AB="11"	else
				
			fABAA	 when	Q=fABA	and AB="01"	else
			ERR	 when	Q=fABA	and AB="10"	else
			fABA	 when	Q=fABA	and AB="00"	else
			fABA	 when	Q=fABA	and AB="11"	else
			
			fBBBA	 when	Q=fBBB	and AB="01"	else
			ERR	 when	Q=fBBB	and AB="10"	else
			fBBB   when	Q=fBBB	and AB="00"	else
			fBBB   when	Q=fBBB	and AB="11"	else
			
			ERR	 when	Q=fABAA	and AB="01"	else
			fABAAB when	Q=fABAA	and AB="10"	else
			fABAA when	Q=fABAA	and AB="00"	else
			fABAA when	Q=fABAA	and AB="11"	else
			
			ERR	 when	Q=fBBBA	and AB="01"	else
			fBBBAB when	Q=fBBBA	and AB="10"	else
			fBBBA when	Q=fBBBA	and AB="00"	else
			fBBBA when	Q=fBBBA	and AB="11"	else
	
			ERR	 when	Q=fABAAB	and AB="01"	else
			LOCK	 when	Q=fABAAB	and AB="10"	else
			fABAAB when	Q=fABAAB	and AB="00"	else
			fABAAB when	Q=fABAAB	and AB="11"	else
			
			UNLOCK when	Q=fBBBAB	and AB="01"	else
			ERR	 when	Q=fBBBAB	and AB="10"	else
			fBBBAB when	Q=fBBBAB	and AB="00"	else
			fBBBAB when	Q=fBBBAB	and AB="11"	else
			
			ERR when Q=ERR                   else		
			
			LOCK when Q=LOCK and AB="00" else 
			LOCK when Q=LOCK and AB="11" else 
			
			UNLOCK;

		  
	-- state register
	reg: process(CLR, clk) 
	begin 
		if rising_edge(clk) then 
			if CLR = '0' then Q <= UNLOCK;
			else Q <= D;
			end if;
		end if;
	end process reg;
	
--	--counter process 
--	counter: process (clk)
--	begin	
--		if rising_edge(clk) then 
--			cnt <= cnt+1;
--			if cnt = 25000000 then 
--				clk1Hz <= not clk1Hz;
--				cnt<=0;
--			end if;
--		end if;
--	end process;
	
	-- add this counter process as a separate process in your architecture 
   counter: process(clk) 
   begin 
      if rising_edge(clk) then  
         cnt <= cnt+1; 
			if cnt = 12500000 then  
			  clk1Hz <= not clk1Hz; 
			  cnt <= 0; 
         end if; 
      end if; 
    end process;
	
	-- output logic 
	with Q select 
			  -- k for "unlock","lock","ok"
	HEX0 <= B"10001010" when fA|fB|fAB|fBB|fABA|fBBB|fABAA|fBBBA|fABAAB|fBBBAB|LOCK|UNLOCK,
	        -- r for "err"
		     B"10101111" when others; 
			  
	with Q select 
	        -- c for "unlock","lock"
	HEX1 <= B"10100111" when LOCK|UNLOCK,
	        -- o for "ok"
		     B"10100011" when fA|fB|fAB|fBB|fABA|fBBB|fABAA|fBBBA|fABAAB|fBBBAB,
			  -- r for "err"
			  B"10101111" when others; 
			  
	with Q select 
	        -- o for "unlock","lock"
	HEX2 <= B"10100011" when LOCK|UNLOCK,
	        -- e for "err"
			  B"10000110" when ERR,
			  -- blank for "ok"
			  B"11111111" when others;
		    
	with Q select 
	        -- l for "lock","unlock"
	HEX3 <= B"11000111" when LOCK|UNLOCK,
	        -- blank for "ok","err"
			  B"11111111" when others;
	
	with Q select 
	        -- n for "unlock"
	HEX4 <= B"10101011" when UNLOCK,
	        -- blank for "ok","err"
	        B"11111111" when others;
			  
	with Q select 
	        -- u for "unlock"
	HEX5 <= B"11100011" when UNLOCK,
	
			  B"11111110" when fA|fBBBAB,
			  B"11111100" when fAB|fBBBA,
			  B"11111000" when fABA|fBBB,
			  B"11110000" when fABAA|fBB,
			  B"11100000" when fABAAB|fB,
			  
	        B"11111111" when others;
			  
	with Q select 
	L <= '1' when LOCK,
	     '0' when others;
		  
	with Q select 
	ALARM <= '1' when ERR,
	         '0' when others;
	
end architecture behavioral;