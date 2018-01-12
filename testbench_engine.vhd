-- ****************************************************************************
-- * PROJECT: LW4 - Engine
-- * FILENAME: testbench_engine.vhd
-- * AUTHOR: boyntonrl <Rock Boynton>
-- * PROVIDES:
-- * - testbench to verify engine reset and operational use cases as defined in
-- *   engine.vhd
-- ****************************************************************************

-- load ieee library 
-- use std_logic, std_logic_vector
library ieee;
use ieee.std_logic_1164.all;

--entity: external view 
-- inputs: none 
-- outputs: none 
entity testbench_engine is 
end entity testbench_engine;

-- architecture: internal circuit 
-- internal signals
--   CLK: sample clock for register 
--   RST: active high sychronous reset 
--   Y3: connects to the spark mechanism of cylinder 3. 
--   Y2: connects to the spark mechanism of cylinder 2.   
--   Y1: connects to the spark mechanism of cylinder 1.   
--   Y0: connects to the spark mechanism of cylinder 0. 
--   Y: bus of Y3,Y2,Y1, and Y0.
architecture dataflow of testbench_engine is 

	signal CLK, RST: std_logic; -- Y3, Y2, Y1, Y0: std_logic
	signal Y: std_logic_vector(3 downto 0);
	
begin 

		-- msp the internal circuits to the engine 
		UUT: entity work.engine
			  port map(CLK=>CLK,RST=>RST,Y=>Y); -- Y3=>Y3,Y2=>Y2,Y1=>Y1,Y0=>Y0
			 
		-- generate a 20ns clock period 
		clock: process 
		begin 
			CLK <= '0'; wait for 10ns;
			CLK <= '1'; wait for 10ns;
		end process clock;
		
		-- test engine with RST driven active low for two clock periods -- figure 1 shows one clock period??
		tester : process
		begin 
			-- test sychronous reset
			RST <= '0', '1' after 20ns;
							
			-- test engine 
			wait;
		end process tester;
		
end architecture dataflow;
		
			