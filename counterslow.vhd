-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 17.0.2 Build 602 07/19/2017 SJ Lite Edition"
-- CREATED		"Mon Dec 11 19:36:53 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY counterslow IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		LD :  IN  STD_LOGIC;
		CLR :  IN  STD_LOGIC;
		U :  IN  STD_LOGIC;
		Q :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		SEGMENT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END counterslow;

ARCHITECTURE bdf_type OF counterslow IS 

COMPONENT seg7decode
	PORT(A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 SEGMENT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT reg4
	PORT(CLR : IN STD_LOGIC;
		 LD : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT nsl
	PORT(U : IN STD_LOGIC;
		 Q : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 D : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT slowclk
	PORT(RST : IN STD_LOGIC;
		 CLK50MHZ : IN STD_LOGIC;
		 CLK1HZ : INOUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;


BEGIN 
Q <= SYNTHESIZED_WIRE_5;
SYNTHESIZED_WIRE_4 <= '0';



b2v_inst : seg7decode
PORT MAP(A => SYNTHESIZED_WIRE_5,
		 SEGMENT => SEGMENT);


b2v_inst1 : reg4
PORT MAP(CLR => CLR,
		 LD => LD,
		 CLK => SYNTHESIZED_WIRE_1,
		 D => SYNTHESIZED_WIRE_2,
		 Q => SYNTHESIZED_WIRE_5);


b2v_inst2 : nsl
PORT MAP(U => U,
		 Q => SYNTHESIZED_WIRE_5,
		 D => SYNTHESIZED_WIRE_2);


b2v_inst3 : slowclk
PORT MAP(RST => SYNTHESIZED_WIRE_4,
		 CLK50MHZ => CLK,
		 CLK1HZ => SYNTHESIZED_WIRE_1);



END bdf_type;