-- ***************************************************************************************
-- * PROJECT: LW7 - Security Alarm Control Panel
-- * FILENAME: lw7.vhd
-- * AUTHOR: boyntonrl@msoe.edu <Rock Boynton>
-- * DESCRIPTION: 
-- * - This specification describes and defines the basic requirements of the CE1911 
-- *   vending machine. The controller accepts coins, displays the current coin total, 
-- *   and dispenses Pepsi and water bottles when enough money has been collected and the 
-- *   user presses a choice button. The machine does not dispense change for coin  
-- *   overage - the coin mechanism drops coins through to the coin return box when enough 
-- *   money has already been inserted. All bottles cost $1.50
-- * REQUIREMENTS: 
-- *   1. The system must accept quarters. No ther coin is accepted. 
-- *   2. The system must reset into a state with a zero cent balance.
-- *   3. The system must provide a coin total on a user display.
-- *   4. The system must spend one second in a state that displays a fixed price of $1.50
-- *      when a vend button is pressed but not enough money has been inserted. This 
-- *      behavior reminds the user that they have not inserted enough money. 
-- *   5. The system must operate from DC powerr or USB supplied power.
-- * USE-CASE EVENTS:
-- *   1. Reset Event  
-- *       A. The service technician or power-on resets the system.  
-- *       B. The system identifies the reset request.
-- *  	  C. The system reponds by resetting into a zero cents balance state. 
-- *   2. Insert Coin 
-- *	     A. The customer inserts a nickel, dime, or quarter.  
-- *       B. Nickels and dimes are dropped to the coin return box by the coin mechanism 
-- *       C. Quarters are accepted and dropped to the cash box.
-- *       D. If a quarter is inserted then the system updates to a new coin balance state.
-- *       E. The system updates the display.
-- *   3. Update Display
-- *       A. An inserted quarter causes a display update.  
-- *       B. The display updates to a new coin balance.
-- *      Aleternate Path 
-- *       A. The user pushes a vend button when insufficient funds are collected.  
-- *       B. The display updates to 1.50 for one second. 
-- *      Alternate Path
-- *       A. The user pushes a vend button when sufficient funds have been collected.
-- *       B. The display updates to Pepsi for one second if Pepsi is selected.
-- *       C. The display updates to Water for one second if Water is selected 
-- *   4. Push Button 
-- *       A. The user pushes a vend button when sufficient funds are collected.
-- *       B. The system vends the selected product.
-- *      Alternate path
-- *       A. The user pushes a vend button when insufficient funds are collected 
-- *       B. The system updates the display for one second with the product price.
-- *   5. Vend Product
-- *       A. The sytem vends the chosen product. Vending requires one second. 
-- *       B. The system returns to the zero cent balance state.  
-- ***************************************************************************************

-- load libraries 
-- use: std_logic
-- use: std_logic_vector
-- use: rising_edge
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration: external-view
-- inputs: 
--    CLK: register sample clock
--    RST: Synchronous register reset
--          i)   Active low pusbutton to request system reset
--          ii)  Active when low
--          iii) Sychronizes to the rising edge of the clock
--    QPW:  A bus of three digitalslide switches 
--          i)   The Q signal is active when a quarter has been inserted.
--          ii)  The P signal is active when the Pepsi selection button has been pressed.
--          iii) The W signal is active when the Water selection button has been pressed.
-- outputs: 
-- 	A. The system outputs two active-high signals called VP and VW, grouped into a bus. 
--        i)  Outout VP drives the vend motor to dispense Pepsi.    
--        ii) Output VW drives the vend motor to dispense water.
--  	B. The system creates 40 digital output signals that drive the LED segments of five
--       7-segment displays mounted on the front panel of the vending machine.
--        i)   The output signals are divided into six 8-bit busses called hex0, hex1, 
--             hex2, hex3, and hex4. 
--        ii)  The system uses the DSEG7 font alpha-numerical font for all numbers and 
--             letter displayed on the 7-segment displays.    
--        iii) Reference: http://www.keshikan.net/fonts-e.html
-- functional specification
--    The system is a Moore finite state machine.  
--    1. The machine enters the reset state when the active-low pushbutton is pressed. 
--       The reset state always transitions to the zero-cent balance state on the next 
--       clock tick. The machine displays RESET on the 7-segment displays when the machine
--       is in the reset state. 
--    2. The machine responds to coin insertions by moving to appropriate balance states.
--    3. The maximum balance state is S150. No change is given for coin overage. 
--    4. The machine responds to vend buttons by vending when $1.50 is collected.
--    5. The machine responds to vend buttons with insufficient funds by displaying $1.50 
--       for one second.
--    6. The machine responds to simultaneous quarter and button signals by ignoring them. 
--       The coin mechanism drops the quarter through to the coin return box.
entity lw7 is
port(CLK  : in  std_logic;
	  RST  : in  std_logic;
	  QPW  : in  std_logic_vector(2 downto 0);
	  VPVW : out std_logic_vector(1 downto 0);
	  HEX0,HEX1,HEX2,HEX3,HEX4: out std_logic_vector(7 downto 0)
	  );
end entity lw7;

-- architecture: internal circuit 
-- signals: 
--   D: Moore FSM next state 
--   Q: Moore FSM current state 
architecture behavioral of lw7 is 

	-- assign pins 
	attribute chip_pin: string;
	attribute chip_pin of CLK:  signal is "P11";
	attribute chip_pin of RST:  signal is "B8";
	attribute chip_pin of QPW:  signal is "D12,C11,C10";
	attribute chip_pin of VPVW: signal is "AB6,AB5";
	attribute chip_pin of HEX0: signal is "D15,C17,D17,E16,C16,C15,E15,C14";
	attribute chip_pin of HEX1: signal is "A16,B17,A18,A17,B16,E18,D18,C18";
	attribute chip_pin of HEX2: signal is "A19,B22,C22,B21,A21,B19,A20,B20";
	attribute chip_pin of HEX3: signal is "D22,E17,D19,C20,C19,E21,E22,F21";
	attribute chip_pin of HEX4: signal is "F17,F20,F19,H19,J18,E19,E20,F18";

   -- 17 total states
	type states is (-- balance states with corresponding display-price states     
	                S0, DPS0, S25,DPS25,S50,DPS50,S75,DPS75,
						 S100,DPS100,S125,DPS125,S150,DPS150,
						 -- vend states
						 VP,VW,
						 -- reset state
						 RESET
						 );
						 
	signal D, Q: states;
	-- signals used to slow down clock to run on DE-10 Lite
	signal cnt: integer range 0 to 12500000; 
	signal clk1Hz: std_logic; 
	
	-- hex display values
	constant zero      : std_logic_vector(7 downto 0) := B"11000000";
	constant zeropoint : std_logic_vector(7 downto 0) := B"01000000";
	constant onepoint  : std_logic_vector(7 downto 0) := B"01111001"; 
	constant two       : std_logic_vector(7 downto 0) := B"10100100"; 
	constant five      : std_logic_vector(7 downto 0) := B"10010010"; 
	constant seven     : std_logic_vector(7 downto 0) := B"11011000";
	constant letterR   : std_logic_vector(7 downto 0) := B"10101111";
	constant letterE   : std_logic_vector(7 downto 0) := B"10000100";
	constant letterS   : std_logic_vector(7 downto 0) := B"10010011";
	constant letterT   : std_logic_vector(7 downto 0) := B"10000111";
	constant letterP   : std_logic_vector(7 downto 0) := B"10001100";
	constant letterI   : std_logic_vector(7 downto 0) := B"11111011";
	constant letterW   : std_logic_vector(7 downto 0) := B"10000001";
	constant letterA   : std_logic_vector(7 downto 0) := B"10001000";
	constant blank     : std_logic_vector(7 downto 0) := B"11111111";
 
 begin 
 
	-- next state logic
	-- any state moves to RESET if RST pushbutton is pushed 
	D 	<= S25   when Q=RESET and QPW="100" else 
			S0	   when Q=RESET and QPW="000" else
			S0    when Q=RESET and QPW="101" else 
			S0	   when Q=RESET and QPW="110" else
			S0    when Q=RESET and QPW="111" else 
			S0    when Q=RESET and QPW="001" else
			S0    when Q=RESET and QPW="010" else 
			S0    when Q=RESET and QPW="011" else
	
			S25   when Q=S0    and QPW="100" else 
			S0	   when Q=S0    and QPW="000" else
			S0    when Q=S0    and QPW="101" else 
			S0	   when Q=S0    and QPW="110" else
			S0    when Q=S0    and QPW="111" else 
			DPS0  when Q=S0    and QPW="001" else
			DPS0  when Q=S0    and QPW="010" else 
			DPS0  when Q=S0    and QPW="011" else
			 
			S0    when Q=DPS0                else
			
			S50   when Q=S25   and QPW="100" else 
			S25   when Q=S25   and QPW="000" else
			S25   when Q=S25   and QPW="101" else 
			S25   when Q=S25   and QPW="110" else
			S25   when Q=S25   and QPW="111" else 
			DPS25 when Q=S25   and QPW="001" else
			DPS25 when Q=S25   and QPW="010" else 
			DPS25 when Q=S25   and QPW="011" else
			
			S25   when Q=DPS25               else
			
			S75   when Q=S50   and QPW="100" else 
			S50   when Q=S50   and QPW="000" else
			S50   when Q=S50   and QPW="101" else 
			S50   when Q=S50   and QPW="110" else
			S50   when Q=S50   and QPW="111" else 
			DPS50 when Q=S50   and QPW="001" else
			DPS50 when Q=S50   and QPW="010" else 
			DPS50 when Q=S50   and QPW="011" else
			
			S50   when Q=DPS50               else
			
			S100  when Q=S75   and QPW="100" else 
			S75   when Q=S75   and QPW="000" else
			S75   when Q=S75   and QPW="101" else 
			S75   when Q=S75   and QPW="110" else
			S75   when Q=S75   and QPW="111" else 
			DPS75 when Q=S75   and QPW="001" else
			DPS75 when Q=S75   and QPW="010" else 
			DPS75 when Q=S75   and QPW="011" else
			
			S75   when Q=DPS75               else
			
			S125   when Q=S100 and QPW="100" else 
			S100   when Q=S100 and QPW="000" else
			S100   when Q=S100 and QPW="101" else 
			S100   when Q=S100 and QPW="110" else
			S100   when Q=S100 and QPW="111" else 
			DPS100 when Q=S100 and QPW="001" else
			DPS100 when Q=S100 and QPW="010" else 
			DPS100 when Q=S100 and QPW="011" else
			
			S100   when Q=DPS100             else
			
			S150   when Q=S125 and QPW="100" else 
			S125   when Q=S125 and QPW="000" else
			S125   when Q=S125 and QPW="101" else 
			S125   when Q=S125 and QPW="110" else
			S125   when Q=S125 and QPW="111" else 
			DPS125 when Q=S125 and QPW="001" else
			DPS125 when Q=S125 and QPW="010" else 
			DPS125 when Q=S125 and QPW="011" else
			
			S125   when Q=DPS125             else
			
			S150   when Q=S150 and QPW="100" else 
			S150   when Q=S150 and QPW="000" else
			S150   when Q=S150 and QPW="101" else 
			S150   when Q=S150 and QPW="110" else
			S150   when Q=S150 and QPW="111" else 
			VW     when Q=S150 and QPW="001" else
			VP     when Q=S150 and QPW="010" else 
			S150   when Q=S150 and QPW="011" else
			
			S0     when Q=VW   and QPW="100" else 
			S0     when Q=VW   and QPW="000" else
			S0     when Q=VW   and QPW="101" else 
			S0     when Q=VW   and QPW="110" else
			S0     when Q=VW   and QPW="111" else 
			S0     when Q=VW   and QPW="001" else
			S0     when Q=VW   and QPW="010" else 
			S0     when Q=VW   and QPW="011" else 
			
			S0     when Q=VP   and QPW="100" else 
			S0     when Q=VP   and QPW="000" else
			S0     when Q=VP   and QPW="101" else 
			S0     when Q=VP   and QPW="110" else
			S0     when Q=VP   and QPW="111" else 
			S0     when Q=VP   and QPW="001" else
			S0     when Q=VP   and QPW="010" else 
			S0     when Q=VP   and QPW="011" else
			
			RESET; 
			

		  
	-- state register
	reg: process(RST, clk) -- change to clk1hz for board simulation/ clk for ModelSim
	begin 
		if rising_edge(clk) then -- change to clk1hz for board simulation/ clk for ModelSim
			if RST = '0' then Q <= RESET;
			else Q <= D;
			end if;
		end if;
	end process reg;
	
	-- slow clock counter process 
   counter: process(clk) 
   begin 
      if rising_edge(clk) then  
         cnt <= cnt+1; 
			if cnt = 12500000 then  
			  clk1Hz <= not clk1Hz; 
			  cnt <= 0; 
         end if; 
      end if; 
    end process;
	
	-- output logic 
	with Q select 
			  -- 
	HEX0 <= zero when S0|DPS0|DPS25|S50|DPS50|DPS75|S100|DPS100|DPS125|S150|DPS150,
		     five when S25|S75|S125,
			  letterR when VW,
			  letterI when VP,
			  letterT when others;
			  
	with Q select 
	HEX1 <= zero when S0|S100,
		     two when S25|S125,
			  seven when S75,
			  letterE when VW|RESET,
			  letterS when VP,
			  five when others; 
			  
	with Q select 
	HEX2 <= zeropoint when S0|S25|S50|S75,
			  letterT when VW,
			  letterP when VP,
			  letterS when RESET,
			  onepoint when others;
		    
	with Q select 
	HEX3 <= letterA when VW,
			  letterE when VP|RESET, 	
			  blank when others;
	
	with Q select 
	HEX4 <= letterW when VW,
			  letterP when VP,
	        letterR when RESET,
	        blank when others;
			  
	with Q select 
	VPVW <= "01" when VW,
			  "10" when VP,
	        "00" when others;
	
end architecture behavioral;