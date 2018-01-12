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
-- VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
-- CREATED		"Sun Dec 10 21:38:07 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY counter IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		LD :  IN  STD_LOGIC;
		CLR :  IN  STD_LOGIC;
		U :  IN  STD_LOGIC;
		Q :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		SEGMENT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END counter;

ARCHITECTURE bdf_type OF counter IS 

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

SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 
Q <= SYNTHESIZED_WIRE_3;



b2v_inst : seg7decode
PORT MAP(A => SYNTHESIZED_WIRE_3,
		 SEGMENT => SEGMENT);


b2v_inst1 : reg4
PORT MAP(CLR => CLR,
		 LD => LD,
		 CLK => CLK,
		 D => SYNTHESIZED_WIRE_1,
		 Q => SYNTHESIZED_WIRE_3);


b2v_inst2 : nsl
PORT MAP(U => U,
		 Q => SYNTHESIZED_WIRE_3,
		 D => SYNTHESIZED_WIRE_1);


END bdf_type;