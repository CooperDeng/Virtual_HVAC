library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Energy_Monitor is port(
		AGTB	    	  :in std_logic;
		AEQB		     :in std_logic;
		ALTB		     :in std_logic;
		vacation_mode :in std_logic;
		MC_test_mode  :in std_logic;
		window_open   :in std_logic;
		door_open     :in std_logic;
		furnace		  :out std_logic;
		at_temp       :out std_logic;
		AC				  :out std_logic;
		blower		  :out std_logic;
		window		  :out std_logic;
		door    		  :out std_logic;
		vacation		  :out std_logic;
		dec			  :out std_logic;
		inc			  :out std_logic;
		run_n			  :out std_logic
);

end Energy_Monitor;


architecture Energy_Monitor_circuit of Energy_Monitor is

begin
	run_n   <= AEQB or window_open or door_open or MC_test_mode;
	AC      <= ALTB;
	furnace <= AGTB;
	at_temp <= AEQB;
	blower  <= not AEQB AND (not(MC_test_mode or window_open or door_open));
	window  <= window_open;
	door    <= door_open;
	vacation<= vacation_mode;
	
--no need for extra conditions for inc or dec as the HVAC unit would ingnore them
--when the run_n signal is deactivated
	inc     <= AGTB;
	dec     <= ALTB;

end architecture Energy_monitor_circuit;