-- **************************************************************************************
-- * PROJECT: LW7 - Vending Machine
-- * FILENAME: testbench_lw7.vhd
-- * AUTHOR: boyntonrl <Rock Boynton>
-- * PROVIDES:
-- * - testbench to verify vending machine reset and operational use cases as defined in
-- *   lw7.vhd
-- **************************************************************************************

-- load ieee library 
-- use std_logic, std_logic_vector
library ieee;
use ieee.std_logic_1164.all;

--entity: external view 
-- inputs: none 
-- outputs: none 
entity testbench_lw7 is 
end entity testbench_lw7;

-- architecture: internal circuit 
-- internal signals
--   CLK: sample clock for register 
--   RST: active high sychronous register reset
--   QPW:  A bus of three digital inputs to allow quarter entry and vend choice; produce 
--         logic-0 when pressed  
--   VPVW: output to drive vend motors to vend water or pepsi  
--   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: six 7-segment displays to display messages
architecture dataflow of testbench_lw7 is 

	signal CLK, RST: std_logic; 
	signal QPW: std_logic_vector(2 downto 0);
	signal VPVW: std_logic_vector(1 downto 0);
	signal HEX0,HEX1,HEX2,HEX3,HEX4: std_logic_vector(7 downto 0);
	
begin 

		-- map the internal circuits to the engine 
		UUT: entity work.lw7
			  port map(CLK=>CLK,RST=>RST,QPW=>QPW,VPVW=>VPVW,HEX0=>HEX0,HEX1=>HEX1,
						  HEX2=>HEX2,HEX3=>HEX3,HEX4=>HEX4); 
			 
		-- generate a 1s clock period 
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
			    -- test sequence 
			QPW <= "000","100" after 2sec,"010" after 4sec,"000" after 5sec, "011" after 6sec,
					 "000" after 7sec,"100" after 8sec, "000" after 15sec,"011" after 16sec;
					 
			    
			-- test vending machine
			wait;
		end process tester;
		
end architecture dataflow;
		
			