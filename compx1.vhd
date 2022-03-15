library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compx1 is port (

	A,B		        :in std_logic;
	AGTB, AEQB, ALTB :out std_logic

);
end compx1;


architecture  compx1_logic of compx1 is

-- A and B 			 EQ
-- not A and not B EQ
-- A and notB GT
-- notA and B LT

begin 
		
		AGTB <= (A AND (not B));
		AEQB <= (A AND B) or ((not A) AND (not B));
		ALTB <= ((not A) and (B));
		
end architecture compx1_logic;
		