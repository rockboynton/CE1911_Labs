-- ***************************************************************************************
-- * PROJECT: LW9 - Special Purpose Processor
-- * FILENAME: lw9.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - top-level schematic of a special purpose processor implemented as structural VHDL
-- ***************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: rising_edge
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration: external-view
-- inputs: 
--    CLK:      Register file sample clock
--    RST:      Synchronous register file reset
--               i)   Active when low
--    WR:       Write control signal 
--               i)   It is connected to the address decoder. 
--    RDADDR_A: Address bus input for first register to be read from
--    RDADDR_B: Address bus input for second register to be read from
--    WRADDR:   Address bus input for register to written to to
--    WRDATA:   Data signal to write data  
-- outputs: 
-- 	A. The system outputs two active-high signals called A and B. What are they?
entity lw9 is
port(CLK      : in  std_logic;
	  RST      : in  std_logic;
	  GO       : in  std_logic;
	  SLIDERS  : in  std_logic_vector(9 downto 0);
--	  X,Y      : in  std_logic_vector(3 downto 0);
	  SEG75,SEG74,SEG73,SEG72,SEG71,SEG70   : out  std_logic_vector(7 downto 0)
	  );
end entity lw9;
 
architecture structural of lw9 is

	-- assign pins 
	attribute chip_pin: string;
	attribute chip_pin of CLK:      signal is "P11";
	attribute chip_pin of RST:      signal is "B8";
	attribute chip_pin of GO:       signal is "A7";
	attribute chip_pin of SLIDERS:  signal is "F15,B14,A14,A13,B12,A12,C12,D12,C11,C10";
	attribute chip_pin of SEG70:    signal is "D15,C17,D17,E16,C16,C15,E15,C14";
	attribute chip_pin of SEG71:    signal is "A16,B17,A18,A17,B16,E18,D18,C18";
	attribute chip_pin of SEG72:    signal is "A19,B22,C22,B21,A21,B19,A20,B20";
	attribute chip_pin of SEG73:    signal is "D22,E17,D19,C20,C19,E21,E22,F21";
	attribute chip_pin of SEG74:    signal is "F17,F20,F19,H19,J18,E19,E20,F18";
	attribute chip_pin of SEG75:    signal is "L19,N20,N19,M20,N18,L18,K20,J20";	
						 
	signal Y      : std_logic_vector(7 downto 0);
	signal F      : std_logic_vector(7 downto 0);
	signal QA     : std_logic_vector(7 downto 0);
	signal QB     : std_logic_vector(7 downto 0);
	signal LDA    : std_logic;
	signal LDB    : std_logic;
	signal MUXS   : std_logic_vector(1 downto 0);
	signal ALUS   : std_logic_vector(2 downto 0);
	signal DISPSEL: std_logic_vector(2 downto 0);
	
	signal clk1Hz: std_logic; 
	
 begin 
	 
--	Slwclk:     entity work.clk1Hz
--					port map(CLK=>CLK,RST=>RST,clk1Hz=>clk1Hz);
 	  
	Reg8_A: 		entity work.reg8
					port map(D=>Y,LD=>LDA,RST=>RST,CLK=>CLK,Q=>QA); -- change to clk1hz for demo
			  
	Reg8_B: 		entity work.reg8
					port map(D=>Y,LD=>LDB,RST=>RST,CLK=>CLK,Q=>QB); -- change to clk1hz for demo
			  
	Controller: entity work.controller
					port map(FUNCSEL=>SlIDERS(9 downto 8),GO=>GO,RST=>RST,CLK=>CLK,MUXS=>MUXS, -- change to clk1hz for demo
							   LDA=>LDA,LDB=>LDB,ALUS=>ALUS,DISPSEL=>DISPSEL);
								
	ALU:        entity work.alu
					port map(A=>QA,B=>QB,S=>ALUS,F=>F);
					
	Seg7Decode: entity work.seg7decode
					port map(DATA=>QB,DISPSEL=>DISPSEL,SEG75=>SEG75,SEG74=>SEG74,SEG73=>SEG73,
							   SEG72=>SEG72,SEG71=>SEG71,SEG70=>SEG70);
								
	MyBusMux:   entity work.MyBusMux
					port map(D3=>SLIDERS(7 downto 4),D2=>SLIDERS(3 downto 0),D1=>B"0000",D0=>F,S=>MUXS,Y=>Y); -- DO I HAVE TO PUT D1?
	
end architecture structural;