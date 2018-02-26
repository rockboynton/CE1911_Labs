-- ***************************************************************************************
-- * PROJECT: LW9 - Special Purpose Processor
-- * FILENAME: reg8.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - This specification implements a register in a dataflow VHDL 
-- ***************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: std_logic_unsigned
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- active high load, active low reset 
entity reg8 is 
port(D   : in   std_logic_vector(7 downto 0);
	  LD  : in   std_logic;
	  RST : in   std_logic;
	  CLK : in   std_logic;
	  Q   : out  std_logic_vector(7 downto 0)
	  );
end entity reg8;

-- architecture: internal circuit 
architecture behavioral of reg8 is

begin 

	reg: process(RST, CLK, LD) -- change to clk1hz for board simulation/ clk for ModelSim
	begin 
		if rising_edge(clk) then -- change to clk1hz for board simulation/ clk for ModelSim
			if RST = '0' then Q <= B"00000000";
			elsif LD = '0' then 
				Q <= D;
			end if;
		end if;
	end process reg;
	
end architecture behavioral;