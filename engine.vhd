-- ****************************************************************************
-- * PROJECT: LW4 - Engine
-- * FILENAME: engine.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * PROVIDES: 
-- * - This specification describes and defines the basic requirements of the 
-- *   CE1911 electronic fuel ignition system. The system generates digital 
-- *   pulses on four output signals. Each output signal controls the spark 
-- *	 mechanism of one spark plug in a four cylinder automobile engine. Each 
-- *	 output pulse causes the corresponding spark plug to ignite the 
-- *	 vaporized fuel mixture in the cylinder. The ignition of fuel causes 
-- *	 gas expansion that pushes the piston away from the spark plug thus 
-- *	 creating the power stroke that rotates the crankshaft of the engine. 
-- *	 The crankshaft motion transfers to the gear train and eventually the 
-- *	 axels of the vehicle.  
-- * FUNCTIONS: 
-- *   1. The system generates periodic pulse waveforms on four output signals.  
-- *   2. The system responds to a reset signal activated by an automotive 
-- *      mechanic. 
-- *   3. The system operates from 12V automotive power or USB supplied power. 
-- *   4. The system operates in a high vibration environment.
-- *   5. The system operates in a high temperature environment. 
-- * USE-CASE EVENTS:
-- *   A. The automotive mechanic resets the system. 
-- *   B. The system identifies the reset request. 
-- *   C. The system responds by driving all spark output to logic 0.
-- ****************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: rising_edge
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration: external-view
-- inputs: 
--   CLK: register sample clock
--   RST: sychronous register clear; digital pushbutton; active when low;
--        sychronizes to the rising edge of the clock
-- outputs: 
--   Y3: connects to the spark mechanism of cylinder 3. 
--   Y2: connects to the spark mechanism of cylinder 2.   
--   Y1: connects to the spark mechanism of cylinder 1.   
--   Y0: connects to the spark mechanism of cylinder 0.  
--   Y: bus of Y3,Y2,Y1, and Y0.
--   A spark fires as the output transitions from logic 0 to logic 1.  
-- behavior summary
--    - The system is a Moore finite state machine
--    - The machine enters the reset state when the active-low pushbutton is 
--      pushed. 
--    - The machine stays in the reset state as long as the pushbutton is
--      pushed.  
--    - The machine uses twenty states to generate the repeating pulse train
--      shown. 
--    - The total number of machine states is twenty-one.   

entity engine is
port(CLK: in std_logic;
	  RST: in std_logic;
	  Y: out std_logic_vector(3 downto 0)	 
	  );
end entity engine;

-- architecture: internal circuit 
-- signals: 
--   D: Moore FSM next state 
--   Q: Moore FSM current state 
architecture behavioral of engine is 
   --each output waveform stays high for 5 states 
	type states is (--reset state     
	                S0,
					    -- Y3 output states
						 S1,S2,S3,S4,S5,
						 -- Y2 output states
						 S6,S7,S8,S9,S10,
						 -- Y1 output states 
						 S11,S12,S13,S14,S15,
						 -- Y0 output states 
						 S16,S17,S18,S19,S20
						 );
						 
	signal D, Q: states;
 
 begin 
 
	-- next state logic
	-- any state moves to S0 if RST pushbutton is pressed 
	D <= --S0 when Q=S else
		  S1 when Q=S0 or Q=S20 else            
		  S2 when Q=S1 else   
		  S3 when Q=S2 else   
		  S4 when Q=S3 else   
		  S5 when Q=S4 else   
		  S6 when Q=S5 else   
		  S7 when Q=S6 else   
		  S8 when Q=S7 else   
		  S9 when Q=S8 else   
		  S10 when Q=S9 else 
		  S11 when Q=S10 else 
		  S12 when Q=S11 else 
		  S13 when Q=S12 else 
		  S14 when Q=S13 else 
		  S15 when Q=S14 else 
		  S16 when Q=S15 else 
		  S17 when Q=S16 else 
		  S18 when Q=S17 else 
		  S19 when Q=S18 else 
		  S20 when Q=S19 else
		  S20;
		  
	-- state register
	reg: process(RST, CLK) 
	begin 
		if rising_edge(CLK) then 
			if RST = '0' then Q <= S0;
			else Q <= D;
			end if;
		end if;
	end process reg;
	
	-- output logic 
	with Q select 
	
	Y <= B"1000" when S1|S2|S3|S4|S5,
		  B"0100" when S6|S7|S8|S9|S10,
		  B"0010" when S11|S12|S13|S14|S15, 
		  B"0001" when S16|S17|S18|S19|S20,
		  B"0000" when others;
	
end architecture behavioral;