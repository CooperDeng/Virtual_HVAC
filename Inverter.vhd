library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Inverter is port(
	pb_n3			: in std_logic;
	pb_n2			: in std_logic;
	pb_n1			: in std_logic;
	pb_n0			: in std_logic;
	AH_pb_n3		: out std_logic;
	AH_pb_n2		: out std_logic;
	AH_pb_n1		: out std_logic;
	AH_pb_n0		: out std_logic
);

end Inverter;

architecture Inverter_logic of Inverter is

begin

	AH_pb_n3 <= not pb_n3;
	AH_pb_n2 <= not pb_n2;
	AH_pb_n1 <= not pb_n1;
	AH_pb_n0 <= not pb_n0;

end architecture Inverter_logic;