-- **************************************************************************************
-- * PROJECT: LW5 - Traffic Light 
-- * FILENAME: traffic.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * PROVIDES: 
-- * - This specification describes and defines the basic requirements of the 
-- *   CE1911 traffic light controller. The controller coordinates traffic flow 
-- *   at a standard + shaped intersection without turn lanes by generating six 
-- *   digital voltages that turn on and off the red, yellow, and green lights. 
-- *   The controllerdoes not coordinate pedestrian flow because 
-- *   this intersection is in a rural area with no sidewalks.  
-- * FUNCTIONS: 
-- *   1. The system never allows traffic to move simultaneously in both directions.   
-- *   2. The system resets into a state with traffic stopped in both directions. 
-- *   3. The system provides 20 seconds of green light. 
-- *   4. The system provides 6 seconds of yellow light. 
-- *   5. The system provides 3 seconds of red light in both directions before green. 
-- *   6. The system provides status information on a 7-segment display. 
-- *   7. The system operates from standard line power or USB supplied power. 
-- * USE-CASE EVENTS:
-- *   1. Reset event
-- *   	A. The service technician or a power-on event resets the system.  
-- *   	B. The system identifies the reset request. 
-- *   	C. The system responds by lighting red lights in both traffic directions. 
-- **************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: rising_edge
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration: external-view
-- inputs: 
--    CLK: register sample clock
--    RST: sychronous register clear; digital pushbutton; active when low;
--        sychronizes to the rising edge of the clock
-- outputs: 
-- 	A. The system creates four digital outputs called R1,Y1,Gl,R2,Y2,G2. 
--    	R1: connects to the red LED lamps mounted on the poles facing 
--           direction one. 
--    	Yl: connects to the yellow LED lamps mounted on the poles facing 
--           direction one. 
--    	G1: connects to the green LED lamps mounted on the poles facing 
--           direction one. 
--       R2: connects to the red LED lamps mounted on the poles facing 
--           direction two. 
--       Y2: connects to the yellow LED lamps mounted on the poles facing 
--           direction two. 
--       G2: connects to the green LED lamps mounted on the poles facing 
--           direction two.   
--       The outputs are grouped in the order R1,Y1,G1,R2,Y2,G2 as an output bus
--       LEDS[5..O]. 
--  	B. The system provides fourteen digital output signals that drive the LED 
--       segments of a two character 7-segment display mounted in the system 
--       pedestal located on the street corner. A service technician can monitor 
--       system behavior by reading status text. 
--       See report for what these statuses are.
-- functional specification
--    1. The system is a Moore finite state machine
--    2. The machine enters the reset state when the active-low pushbutton is 
--       pushed. 
--    3. The reset state has traffic stopped in both directions. 
--    4. The machine coordinates traffic flow and status outputs using its output 
--       signals. Figure 1 in the System Design Specifications documents the 
--       lamp control signals in top-to-bottom order RI, Y 1, Gl, R2, Y2, G2.  

entity traffic is
port(CLK: in std_logic;
	  RST: in std_logic;
	  LEDS: out std_logic_vector(5 downto 0);
	  SEG7: out std_logic_vector(13 downto 0)  
	  );
end entity traffic;

-- architecture: internal circuit 
-- signals: 
--   D: Moore FSM next state 
--   Q: Moore FSM current state 
architecture behavioral of traffic is 
   -- 58 total states
	type states is (-- reset state/1st simultaneous red state      
	                S0,
						 -- next 2 simultaneous red states before direction 1 turns green
						 S1, S2,
					    -- 20 green states for direction 1, red for direction 2
						 G1R2_1,G1R2_2,G1R2_3,G1R2_4,G1R2_5,G1R2_6,G1R2_7,G1R2_8,G1R2_9,
						 G1R2_10,G1R2_11,G1R2_12,G1R2_13,G1R2_14,G1R2_15,G1R2_16,G1R2_17,
						 G1R2_18,G1R2_19,G1R2_20,
						 -- 6 yellow states for direction 1, red for direction 2
						 Y1R2_1,Y1R2_2,Y1R2_3,Y1R2_4,Y1R2_5,Y1R2_6,
						 -- 3 simultaneous red states before direction 2 turns green 
						 S3,S4,S5,
						 -- 20 red states for direction 1, green for direction 2 
						 R1G2_1,R1G2_2,R1G2_3,R1G2_4,R1G2_5,R1G2_6,R1G2_7,R1G2_8,R1G2_9,
						 R1G2_10,R1G2_11,R1G2_12,R1G2_13,R1G2_14,R1G2_15,R1G2_16,R1G2_17,
						 R1G2_18,R1G2_19,R1G2_20,
						 -- 6 red states for direction 1, yellow for direction 2
						 R1Y2_1,R1Y2_2,R1Y2_3,R1Y2_4,R1Y2_5,R1Y2_6
						 );
						 
	signal D, Q: states;
	
	signal cnt: integer range 0 to 25000000;
	signal clk1Hz : std_logic;
 
 begin 
 
	-- next state logic
	-- any state moves to S0 if RST pushbutton is pressed 
	D <= S0 when Q=R1Y2_6 else
		  S1 when Q=S0  else            
		  S2 when Q=S1 else   
		  G1R2_1 when Q=S2 else   
		  G1R2_2 when Q=G1R2_1 else   
		  G1R2_3 when Q=G1R2_2 else   
		  G1R2_4 when Q=G1R2_3 else   
		  G1R2_5 when Q=G1R2_4 else   
		  G1R2_6 when Q=G1R2_5 else   
		  G1R2_7 when Q=G1R2_6 else   
		  G1R2_8 when Q=G1R2_7 else 
		  G1R2_9 when Q=G1R2_8 else 
		  G1R2_10 when Q=G1R2_9 else 
		  G1R2_11 when Q=G1R2_10 else 
		  G1R2_12 when Q=G1R2_11 else 
		  G1R2_13 when Q=G1R2_12 else 
		  G1R2_14 when Q=G1R2_13 else 
		  G1R2_15 when Q=G1R2_14 else 
		  G1R2_16 when Q=G1R2_15 else 
		  G1R2_17 when Q=G1R2_16 else
		  G1R2_18 when Q=G1R2_17 else 
		  G1R2_19 when Q=G1R2_18 else 
		  G1R2_20 when Q=G1R2_19 else 
		  Y1R2_1 when Q=G1R2_20 else 
		  Y1R2_2 when Q=Y1R2_1 else 
		  Y1R2_3 when Q=Y1R2_2 else 
		  Y1R2_4 when Q=Y1R2_3 else 
		  Y1R2_5 when Q=Y1R2_4 else 
		  Y1R2_6 when Q=Y1R2_5 else 
		  S3 when Q=Y1R2_6 else 
		  S4 when Q=S3 else
		  S5 when Q=S4 else
		  R1G2_1 when Q=S5 else
		  R1G2_2 when Q=R1G2_1 else
		  R1G2_3 when Q=R1G2_2 else
		  R1G2_4 when Q=R1G2_3 else
		  R1G2_5 when Q=R1G2_4 else
		  R1G2_6 when Q=R1G2_5 else
		  R1G2_7 when Q=R1G2_6 else
		  R1G2_8 when Q=R1G2_7 else
		  R1G2_9 when Q=R1G2_8 else
		  R1G2_10 when Q=R1G2_9 else
		  R1G2_11 when Q=R1G2_10 else
		  R1G2_12 when Q=R1G2_11 else
		  R1G2_13 when Q=R1G2_12 else
		  R1G2_14 when Q=R1G2_13 else
		  R1G2_15 when Q=R1G2_14 else
		  R1G2_16 when Q=R1G2_15 else
		  R1G2_17 when Q=R1G2_16 else
	     R1G2_18 when Q=R1G2_17 else
		  R1G2_19 when Q=R1G2_18 else
		  R1G2_20 when Q=R1G2_19 else
		  R1Y2_1 when Q=R1G2_20 else
		  R1Y2_2 when Q=R1Y2_1 else
		  R1Y2_3 when Q=R1Y2_2 else
		  R1Y2_4 when Q=R1Y2_3 else
		  R1Y2_5 when Q=R1Y2_4 else
		  R1Y2_6 when Q=R1Y2_5 else
		  S0;
		  
	-- state register
	reg: process(RST, clk1Hz) 
	begin 
		if rising_edge(clk1Hz) then 
			if RST = '0' then Q <= S0;
			else Q <= D;
			end if;
		end if;
	end process reg;
	
	--counter process 
	counter: process (clk)
	begin	
		if rising_edge(clk) then 
			cnt <= cnt+1;
			if cnt = 25000000 then 
				clk1Hz <= not clk1Hz;
				cnt<=0;
			end if;
		end if;
	end process;
	
	-- output logic 
	with Q select 
	        
	LEDS <= B"110011" when G1R2_1|G1R2_2|G1R2_3|G1R2_4|G1R2_5|G1R2_6|G1R2_7|G1R2_8|G1R2_9|
						        G1R2_10|G1R2_11|G1R2_12|G1R2_13|G1R2_14|G1R2_15|G1R2_16|
								  G1R2_17|G1R2_18|G1R2_19|G1R2_20,
		     B"101011" when Y1R2_1|Y1R2_2|Y1R2_3|Y1R2_4|Y1R2_5|Y1R2_6,
		     B"011110" when R1G2_1|R1G2_2|R1G2_3|R1G2_4|R1G2_5|R1G2_6|R1G2_7|R1G2_8|R1G2_9|
						        R1G2_10|R1G2_11|R1G2_12|R1G2_13|R1G2_14|R1G2_15|R1G2_16|
								  R1G2_17|R1G2_18|R1G2_19|R1G2_20, 
		     B"011101" when R1Y2_1|R1Y2_2|R1Y2_3|R1Y2_4|R1Y2_5|R1Y2_6,
		     B"011011" when others;
			  
	with Q select 
	
	SEG7 <= B"01000011001111" when G1R2_1|G1R2_2|G1R2_3|G1R2_4|G1R2_5|G1R2_6|G1R2_7|G1R2_8|G1R2_9|
						        G1R2_10|G1R2_11|G1R2_12|G1R2_13|G1R2_14|G1R2_15|G1R2_16|
								  G1R2_17|G1R2_18|G1R2_19|G1R2_20,
		     B"11001001110001" when Y1R2_1|Y1R2_2|Y1R2_3|Y1R2_4|Y1R2_5|Y1R2_6|R1Y2_1|R1Y2_2|R1Y2_3|R1Y2_4|R1Y2_5|R1Y2_6,
		     B"01000010010010" when R1G2_1|R1G2_2|R1G2_3|R1G2_4|R1G2_5|R1G2_6|R1G2_7|R1G2_8|R1G2_9|
						        R1G2_10|R1G2_11|R1G2_12|R1G2_13|R1G2_14|R1G2_15|R1G2_16|
								  R1G2_17|R1G2_18|R1G2_19|R1G2_20, 
		     B"11001001110000" when others;
	
end architecture behavioral;
