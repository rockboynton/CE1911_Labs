library ieee;
use ieee.std_logic_1164.all;

entity testbench_counter is 
end entity testbench_counter;

architecture dataflow of testbench_counter is 

	signal CLK, U, CLR, LD: std_logic;            -- control signals
	signal Q : std_logic_vector(3 downto 0);      -- memory output
	signal SEGMENT: std_logic_vector(7 downto 0); -- data inputs
	
begin

	--place the unit under testbench_counter
	UUT: entity work.counter port map (U=>U,CLK=>CLK,LD=>LD,CLR=>CLR,
	                                   Q=>Q,SEGMENT=>SEGMENT);
												  
	-- write the process to generate the clock square wave
	clock: process
	begin
		CLK <= '0'; wait for 50ns;
		CLK <= '1'; wait for 50ns;
	end process clock;
	
	-- write the systematic process of testing: time delayed voltage changes
	test: process
	begin
		CLR <= '1', '0' after 200ns; -- keep CLR active 2 clock periods
		U <= '1', '0' after 2200ns;  -- count up for 20 clocks + 2 clear
		LD <= '1';                   -- always sample D
		wait;
	end process test;
	
end architecture dataflow;