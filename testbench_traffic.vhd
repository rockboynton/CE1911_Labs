-- **************************************************************************************
-- * PROJECT: LW5 - Traffic
-- * FILENAME: testbench_traffic.vhd
-- * AUTHOR: boyntonrl <Rock Boynton>
-- * PROVIDES:
-- * - testbench to verify traffic light reset and operational use cases as defined in
-- *   traffic.vhd
-- **************************************************************************************

-- load ieee library 
-- use std_logic, std_logic_vector
library ieee;
use ieee.std_logic_1164.all;

--entity: external view 
-- inputs: none 
-- outputs: none 
entity testbench_traffic is 
end entity testbench_traffic;

-- architecture: internal circuit 
-- internal signals
--   CLK: sample clock for register 
--   RST: active high sychronous reset 
--   R1: connects to the red LED lamps mounted on the poles facing 
--       direction one. 
--   Yl: connects to the yellow LED lamps mounted on the poles facing 
--       direction one. 
--   G1: connects to the green LED lamps mounted on the poles facing 
--       direction one. 
--   R2: connects to the red LED lamps mounted on the poles facing 
--       direction two. 
--   Y2: connects to the yellow LED lamps mounted on the poles facing 
--       direction two. 
--   G2: connects to the green LED lamps mounted on the poles facing 
--       direction two. 
--   The outputs are grouped in the order R1,Y1,G1,R2,Y2,G2 as an output bus
--       LEDS[5..O].    
architecture dataflow of testbench_traffic is 

	signal CLK, RST: std_logic; 
	signal LEDS: std_logic_vector(5 downto 0);
	signal SEG7: std_logic_vector(13 downto 0);
	
begin 

		-- map the internal circuits to the engine 
		UUT: entity work.traffic
			  port map(CLK=>CLK,RST=>RST,LEDs=>LEDS,SEG7=>SEG7); 
			 
		-- generate a 1000ms clock period 
		clock: process 
		begin 
			CLK <= '0'; wait for 500ms;
			CLK <= '1'; wait for 500ms;
		end process clock;
		
		-- test engine with RST driven active low for two clock periods 
		tester : process
		begin 
			-- test sychronous reset
			RST <= '0', '1' after 2000ms;
							
			-- test traffic light  
			wait;
		end process tester;
		
end architecture dataflow;
		
			