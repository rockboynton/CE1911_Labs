-- **************************************************************************************
-- * PROJECT: LW6 - Security Alarm Control Panel
-- * FILENAME: testbench_lw6.vhd
-- * AUTHOR: boyntonrl <Rock Boynton>
-- * PROVIDES:
-- * - testbench to verify traffic light reset and operational use cases as defined in
-- *   lw6.vhd
-- **************************************************************************************

-- load ieee library 
-- use std_logic, std_logic_vector
library ieee;
use ieee.std_logic_1164.all;

--entity: external view 
-- inputs: none 
-- outputs: none 
entity testbench_lw6 is 
end entity testbench_lw6;

-- architecture: internal circuit 
-- internal signals
--   CLK: sample clock for register 
--   CLR: active high sychronous register clear 
--   AB:  A bus of two digital inputs to allow code entry; produce logic-0 when 
--         pressed  
--   L: active high signal for the lock mechanism. (logic-1 = locked)
--   ALARM: active low sonic-alert. (logic-1 = make alarm sound) 
--   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: six 7-segment displays to display messages
architecture dataflow of testbench_lw6 is 

	signal CLK, CLR: std_logic; 
	signal AB: std_logic_vector(1 downto 0);
	signal L: std_logic;
	signal ALARM: std_logic;
	signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5: std_logic_vector(7 downto 0);
	
begin 

		-- map the internal circuits to the engine 
		UUT: entity work.lw6
			  port map(CLK=>CLK,CLR=>CLR,AB=>AB,L=>L,ALARM=>ALARM,HEX0=>HEX0,HEX1=>HEX1,
						  HEX2=>HEX2,HEX3=>HEX3,HEX4=>HEX4,HEX5=>HEX5); 
			 
		-- generate a 1000ms clock period 
		clock: process 
		begin 
			CLK <= '0'; wait for 250ms;
			CLK <= '1'; wait for 250ms;
		end process clock;
		
		-- test engine with RST driven active low for two clock periods 
		tester : process
		begin 
			    -- test sychronous reset
			CLR <= '0', '1' after 1000ms;
			    -- test correct lock code 
			AB  <= "11","01" after 1sec,"10" after 1.5sec,"01" after 2sec,"01" after 2.5sec,
					 "10" after 3sec,"10" after 3.5sec,
			    -- test correct unlock code 
					 "10" after 4sec,"10" after 4.5sec,"10"after 5sec,"01"after 5.5sec,
					 "10"after 6sec,"01"after 6.5sec;	
			-- test security alarm control panel   
			wait;
		end process tester;
		
end architecture dataflow;
		
			