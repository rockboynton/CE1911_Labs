---- **************************************************************************************
---- * PROJECT: LW8 - Register File
---- * FILENAME: testbench_regfile.vhd
---- * AUTHOR: boyntonrl <Rock Boynton>
---- * PROVIDES:
---- * - testbench to verify register file operations
---- **************************************************************************************
--
---- load ieee library 
---- use std_logic, std_logic_vector
--library ieee;
--use ieee.std_logic_1164.all;
--
----entity: external view 
---- inputs: none 
---- outputs: none 
--entity testbench_regfile is 
--end entity testbench_regfile;
--
---- architecture: internal circuit 
---- internal signals
----    CLK:      Register file sample clock
----    RST:      Synchronous register file reset
----    WR:       Write control signal 
----    RDADDR_A: Address bus input for first register to be read from
----    RDADDR_B: Address bus input for second register to be read from
----    WRADDR:   Address bus input for register to written to to
----    WRDATA:   Data signal to write data 
----    A, B:     Two digital output busses 
--architecture dataflow of testbench_regfile is 
--	
--	signal CLK      :  std_logic;
--	signal RST      :  std_logic;
--	signal WR       :  std_logic;
--	signal RDADDR_A :  std_logic_vector(1 downto 0);
--	signal RDADDR_B :  std_logic_vector(1 downto 0);
--	signal WRADDR   :  std_logic_vector(1 downto 0);
--	signal WRDATA   :  std_logic_vector(7 downto 0);
--	signal A, B     :  std_logic_vector(7 downto 0);
--	
--begin 
--
--		-- map the internal circuits to the engine 
--		UUT: entity work.regfile
--			  port map(CLK=>CLK,RST=>RST,WR=>WR,RDADDR_A=>RDADDR_A,RDADDR_B=>RDADDR_B,
--				        WRADDR=>WRADDR,WRDATA=>WRDATA,A=>A,B=>B); 
--			 
--		-- generate a 1ms clock period 
--		clock: process 
--		begin 
--			CLK <= '0'; wait for 500us;
--			CLK <= '1'; wait for 500us;
--		end process clock;
--		
--		-- test engine with RST driven active low for two clock periods 
--		tester : process
--		begin 
--			    -- test sychronous reset to make sure all registers zero
--			RST <= '0', '1' after 2ms,'0' after 11ms;
--			    -- test sequence
--				 -- read behavior  
--			RDADDR_A <= "00","00" after 2ms,"10" after 3ms,"00" after 5ms,"01" after 6ms,
--			            "00" after 8ms,"10" after 10ms,"00" after 12ms,"10" after 13ms;
--			RDADDR_B <= "00","01" after 2ms,"11" after 3ms,"01" after 5ms,"10" after 6ms,
--			            "11" after 8ms,"01" after 10ms,"01" after 12ms,"11" after 13ms;
--				 -- write behavior
--			WRADDR   <= "00","01" after 4ms,"00" after 7ms,"10" after 9ms;
--			WRDATA   <= "00000000","00001001" after 4ms,"00001101" after 7ms,
--			            "00000110" after 9ms;
--			WR       <= '0','0' after 4ms;
--			    
--			-- test register file 
--			wait; 
--		end process tester;
--		
--end architecture dataflow;