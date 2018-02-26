-- ***************************************************************************************
-- * PROJECT: LW9 - Special Purpose Processor
-- * FILENAME: alu.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - This specification implements a arithmetic logic unit in a dataflow VHDL 
-- ***************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: std_logic_unsigned
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- entity declaration: external-view
-- inputs: 
--    A: First operand
--    B: Second operand
--    S: Select which function to use to calculate output 
-- outputs: 
-- 	F: Calculation result
entity alu is
port(A : in  std_logic_vector(7 downto 0);
	  B : in  std_logic_vector(7 downto 0);
	  S : in  std_logic_vector(2 downto 0);
	  F : out  std_logic_vector(7 downto 0)
	  );
end entity alu;

-- architecture: internal circuit 
architecture dataflow of alu is
 
begin 

	with S select 
	F <= B"00000000" when B"000",
		  B"00000001" when B"001",
		  B - 1 when B"010",
		  A + B when B"011",
		  A - B when B"100",
		  A + A when B"101",
		  A and B when B"110",
		  A or B when others; 
	
end architecture dataflow;