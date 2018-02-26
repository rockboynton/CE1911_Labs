-- ***************************************************************************************
-- * PROJECT: LW9 - Special Purpose Processor
-- * FILENAME: alu.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - This specification implements a seven segment decoder in a dataflow VHDL 
-- ***************************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;

--Inputs:  A, a vector of the unsigned binary code
--         E, an enable, active LOW
--Outputs: Y, a vector of the output, each bit corresponding to a part of the seven segment decoder
--            as defined by the DE-10 lite manual

-- DISPSEL encoding:
--    "000" SPC on
--    "001" READY
--    "010" HEX Value(from data)
--    all others reserved for future use


entity seg7decode is 
	port(
		DATA:    in std_logic_vector(7 downto 0);
		DISPSEL: in std_logic_vector(2 downto 0);
		SEG75,SEG74,SEG73,SEG72,SEG71,SEG70: out std_logic_vector(7 downto 0)
		);
end entity seg7decode;

--Uses a with/select (mux) for each bit on the output bus Y
--Uses another mux for the enable bit (active LOW)
architecture dataflow of seg7decode is 

	-- HEX values
	constant zero      : std_logic_vector(7 downto 0) := B"11000000"; 
	constant one       : std_logic_vector(7 downto 0) := B"11111001"; 
	constant two       : std_logic_vector(7 downto 0) := B"10100100";
	constant three     : std_logic_vector(7 downto 0) := B"10110000";
	constant four      : std_logic_vector(7 downto 0) := B"10011001"; 
	constant five      : std_logic_vector(7 downto 0) := B"10010010"; 
	constant six       : std_logic_vector(7 downto 0) := B"10000010"; 
	constant seven     : std_logic_vector(7 downto 0) := B"11011000"; 
	constant eight     : std_logic_vector(7 downto 0) := B"10000000"; 
	constant nine      : std_logic_vector(7 downto 0) := B"10011000"; 
	constant letterA   : std_logic_vector(7 downto 0) := B"10001000"; 
	constant letterB   : std_logic_vector(7 downto 0) := B"10000011"; 
	constant letterC   : std_logic_vector(7 downto 0) := B"10100111"; 
	constant letterD   : std_logic_vector(7 downto 0) := B"10100001"; 
	constant letterE   : std_logic_vector(7 downto 0) := B"10000110"; 
	constant letterF   : std_logic_vector(7 downto 0) := B"10001110"; 
	
	-- other letters needed to display "SPC ON" and "READY"
	constant letterS   : std_logic_vector(7 downto 0) := B"10010011"; 
	constant letterP   : std_logic_vector(7 downto 0) := B"10001100"; 
	constant letterO   : std_logic_vector(7 downto 0) := B"10100011"; 
	constant letterN   : std_logic_vector(7 downto 0) := B"10101011"; 
	constant letterR   : std_logic_vector(7 downto 0) := B"10101111"; 
	constant letterY   : std_logic_vector(7 downto 0) := B"10010001"; 

	constant blank     : std_logic_vector(7 downto 0) := B"11111111"; 
	
	-- data result nibbles
	signal nibble1, nibble0: std_logic_vector(7 downto 0);
	
begin

	with DATA(3 downto 0) select 
	nibble0 <= zero    when B"0000",
				  one     when B"0001",
				  two     when B"0010",
				  three   when B"0011",
				  four    when B"0100",
				  five    when B"0101",
				  six     when B"0110",
				  seven   when B"0111",
				  eight   when B"1000",
				  nine    when B"1001",
				  letterA when B"1010",
				  letterB when B"1011",
				  letterC when B"1100",
				  letterD when B"1101",
				  letterE when B"1110",
				  letterF when others;
				  
	with DATA(7 downto 4) select 
	nibble1 <= zero    when B"0000",
				  one     when B"0001",
				  two     when B"0010",
				  three   when B"0011",
				  four    when B"0100",
				  five    when B"0101",
				  six     when B"0110",
				  seven   when B"0111",
				  eight   when B"1000",
				  nine    when B"1001",
				  letterA when B"1010",
				  letterB when B"1011",
				  letterC when B"1100",
				  letterD when B"1101",
				  letterE when B"1110",
				  letterF when others;
			  
	with DISPSEL select
	SEG75 <= letterS when B"000",
				blank when others;
	
	with DISPSEL select
	SEG74 <= letterP when B"000",
				letterR when B"001",
				blank when others;
	
	with DISPSEL select
	SEG73 <= letterC when B"000",
				letterE when B"001",
				blank when others;
	
	with DISPSEL select
	SEG72 <= letterA when B"001",
				blank when others;
	
	with DISPSEL select
	SEG71 <= letterO when B"000",
				letterD when B"001",
				nibble1 when B"010",
				blank when others;
	
	with DISPSEL select
	SEG70 <= letterN when B"000",
				letterY when B"001",
				nibble0 when B"010",
				blank when others;
		
end architecture dataflow;