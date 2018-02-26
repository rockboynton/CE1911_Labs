-- **************************************************************************************
-- * PROJECT: LW9 - Special Purpose Processor
-- * FILENAME: testbench_lw9.vhd
-- * AUTHOR: boyntonrl <Rock Boynton>
-- * PROVIDES:
-- * - testbench to verify Special Purpose Processor operations
-- **************************************************************************************

-- load ieee library 
-- use std_logic, std_logic_vector
library ieee;
use ieee.std_logic_1164.all;

--entity: external view 
-- inputs: none 
-- outputs: none 
entity testbench_lw9 is 
end entity testbench_lw9;

-- architecture: internal circuit 
architecture dataflow of testbench_lw9 is 
	
	signal CLK      :  std_logic;
	signal RST      :  std_logic;
	signal GO       :  std_logic;
	signal SLIDERS :  std_logic_vector(9 downto 0);
	signal SEG75,SEG74,SEG73,SEG72,SEG71,SEG70:  std_logic_vector(7 downto 0);
	
begin 

		-- map the internal circuits to the processor 
		UUT: entity work.lw9
			  port map(CLK=>CLK,RST=>RST,GO=>GO,SLIDERS=>SLIDERS,SEG75=>SEG75,
				        SEG74=>SEG74,SEG73=>SEG73,SEG72=>SEG72,SEG71=>SEG71,SEG70=>SEG70); 
			 
		-- generate a 1ms clock period 
		clock: process 
		begin 
			CLK <= '0'; wait for 500us;
			CLK <= '1'; wait for 500us;
		end process clock;
		
		tester : process
		begin 
--			test sychronous reset to make sure all registers zero
			RST <= '1','0' after 1ms, '1' after 2ms;
--			    -- test calculation 4
			GO <= '1','0' after 3ms,'1' after 4ms;
			--                            X=2  Y=3
			SLIDERS <= B"0000000000",B"1100100011" after 2ms;
--			-- test register file 
			wait; 
		end process tester;
		
end architecture dataflow;