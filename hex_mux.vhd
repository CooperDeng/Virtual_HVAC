library ieee;
use ieee.std_logic_1164.all;
library work;

entity hex_mux is
 	port (
			hex_num3, hex_num2						   : in std_logic_vector(3 downto 0);
			mux_select 										: in std_logic; 
			hex_out				 							: out std_logic_vector(3 downto 0)
			);

 end hex_mux;

 architecture mux_logic of hex_mux is
 
 
 
 begin
 
 -- complete the with/select construct with the VHDL coding from the Lab Manual for Lab2.
  with mux_select select
  hex_out <= hex_num3 when '0',
			    hex_num2 when '1';
 
 
 end mux_logic;
 
 