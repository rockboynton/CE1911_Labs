-- ***************************************************************************************
-- * PROJECT: LW8 - Register File
-- * FILENAME: regfile.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - This specification implements a register file in a single Quartus behavioral VHDL
-- *   project. 
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
-- 	A. The system outputs two active-high signals called A and B. 
entity regfile is
port(CLK      : in  std_logic;
	  RST      : in  std_logic;
	  WR       : in  std_logic;
	  RDADDR_A : in  std_logic_vector(1 downto 0);
	  RDADDR_B : in  std_logic_vector(1 downto 0);
	  WRADDR   : in  std_logic_vector(1 downto 0);
	  WRDATA   : in  std_logic_vector(7 downto 0);
	  A, B     : out std_logic_vector(7 downto 0)
	  );
end entity regfile;

-- architecture: internal circuit 
-- signals: 
--   D: Moore FSM next state 
--   Q: Moore FSM current state 
architecture behavioral of regfile is
						 
	-- internal circuits of register file
	-- command register 3 to load on the falling edge of the clock
	signal LD3: std_logic;
	-- command register 2 to load on the falling edge of the clock
	signal LD2: std_logic;
	-- command register 1 to load on the falling edge of the clock
	signal LD1: std_logic;
	-- command register 0 to load on the falling edge of the clock
	signal LD0: std_logic;
	-- output of register R3
	signal Q3: std_logic_vector(7 downto 0);
	-- output of register R2
	signal Q2: std_logic_vector(7 downto 0);
	-- output of register Q1
	signal Q1: std_logic_vector(7 downto 0);
	-- output of register R0
	signal Q0: std_logic_vector(7 downto 0);
 
 begin 
 	  
	-- process corresponding to register 3
	reg3: process(rst, clk) 
	begin 
		if falling_edge(clk) then 
			if rst = '0' then Q3 <= B"00000000";
			elsif LD3 = '0' then Q3 <= WRDATA;
			end if;
		end if;
	end process reg3;
	
	-- process corresponding to register 2
	reg2: process(rst, clk) 
	begin 
		if falling_edge(clk) then 
			if rst = '0' then Q2 <= B"00000000";
			elsif LD2 = '0' then Q2 <= WRDATA;
			end if;
		end if;
	end process reg2;
	
	-- process corresponding to register 1
	reg1: process(rst, clk) 
	begin 
		if falling_edge(clk) then 
			if rst = '0' then Q1 <= B"00000000";
			elsif LD1 = '0' then Q1 <= WRDATA;
			end if;
		end if;
	end process reg1;
	
	-- process corresponding to register 0
	reg0: process(rst, clk) 
	begin 
		if falling_edge(clk) then 
			if rst = '0' then Q0 <= B"00000000";
			elsif LD0 = '0' then Q0 <= WRDATA;
			end if;
		end if;
	end process reg0;
	
	-- address decoder
	LD3 <= '0' when WR='0' and WRADDR=B"11" else 
			 '1';
	LD2 <= '0' when WR='0' and WRADDR=B"10" else 
			 '1';
	LD1 <= '0' when WR='0' and WRADDR=B"01" else 
			 '1';
	LD0 <= '0' when WR='0' and WRADDR=B"00" else 
			 '1';
			 
	-- output multiplexars 
	with RDADDR_A select 
	A <= Q3 when B"11", -- and rising_edge(clk)?
	     Q2 when B"10",
		  Q1 when B"01",
		  Q0 when others;
		  
	with RDADDR_B select 
	B <= Q3 when B"11",
	     Q2 when B"10",
		  Q1 when B"01",
		  Q0 when others;
	
	
end architecture behavioral;