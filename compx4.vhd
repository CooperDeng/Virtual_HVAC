library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Compx4 is port(
		 A 					: in std_logic_vector(3 downto 0);
		 
		 B 					: in std_logic_vector(3 downto 0);
		 
		 AGTB, AEQB, ALTB : out std_logic
);
end Compx4;


architecture compx4_logic of compx4 is

component compx1 
	port(

 	A, B   				:in std_logic;
 	AGTB, AEQB, ALTB	:out std_logic
 
	);
end component;


signal   A3GTB3, A2GTB2,
		   A1GTB1, A0GTB0,
		   A3EQB3, A2EQB2,
		   A1EQB1, A0EQB0,
		   A3LTB3, A2LTB2,
		   A1LTB1, A0LTB0: std_logic;

begin


compx_3: compx1 port map (A(3),B(3),A3GTB3,A3EQB3,A3LTB3);

compx_2: compx1 port map (A(2),B(2),A2GTB2,A2EQB2,A2LTB2);

compx_1: compx1 port map (A(1),B(1),A1GTB1,A1EQB1,A1LTB1);

compx_0: compx1 port map (A(0),B(0),A0GTB0,A0EQB0,A0LTB0);

		
	AGTB <= A3GTB3 OR
			  (A3EQB3 AND A2GTB2) OR
			  (A3EQB3 AND A2EQB2 AND A1GTB1) OR
			  (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0GTB0);
	  
	AEQB <= A3EQB3 AND A2EQB2 AND A1EQB1 AND A0EQB0;
	
	ALTB <= A3LTB3 OR
			  (A3EQB3 AND A2LTB2) OR
			  (A3EQB3 AND A2EQB2 AND A1LTB1) OR
			  (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0LTB0);

end architecture compx4_logic;
