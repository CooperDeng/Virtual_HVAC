library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
-------------------------------------------------------------------
-- 				Provided Project Components Used					
------------------------------------------------------------------- 
component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;
	
component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
end component;
----	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run_n		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;



------------------------------------------------------------------
-- 		Add any Other Components here									 --
------------------------------------------------------------------

component Compx4 port(
	   A  : in std_logic_vector(3 downto 0);
		B  : in std_logic_vector(3 downto 0);
		AGTB, AEQB, ALTB	:out std_logic
		);
end component Compx4;


component hex_mux port(
		hex_num3, hex_num2   : in std_logic_vector(3 downto 0);
		mux_select 				: in std_logic; 
		hex_out					: out std_logic_vector(3 downto 0)
		);
end component;


component Energy_Monitor port(
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
end component;

component Inverter port(
		pb_n3			: in std_logic;
		pb_n2			: in std_logic;
		pb_n1			: in std_logic;
		pb_n0			: in std_logic;
		AH_pb_n3		: out std_logic;
		AH_pb_n2		: out std_logic;
		AH_pb_n1		: out std_logic;
		AH_pb_n0		: out std_logic
		);
end component;


------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	

constant HVAC_SIM : boolean := TRUE; -- set to FALSE when compiling for FPGA download to LogicalStep board

------------------------------------------------------------------	
--							SIGNALS												 --
------------------------------------------------------------------
-- global clock
signal clk_in										: std_logic;
signal desired_temp, vacation_temp 			: std_logic_vector(3 downto 0);
-- signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
-- those two signals are going to be defined later with different name
-- signals for the hex_mux
signal mux_temp 	: std_logic_vector(3 downto 0);

-- signals for Inverter
signal vacation_mode		: std_logic;
signal MC_test_mode 		: std_logic;
signal window_open		: std_logic;
signal door_open 			: std_logic;

-- signal for HVAC
signal current_temp		: std_logic_vector(3 downto 0);

-- signals for Compx4
signal AGTB  		: std_logic;
signal AEQB			: std_logic;
signal ALTB			: std_logic;

-- signal for Seven_seg_decoder_1
signal mt_7seg		: std_logic_vector(6 downto 0);

-- signal for Seven_seg_decoder_2
signal ct_7seg		: std_logic_vector(6 downto 0);

-- signal for seven_seg_mux
-- no need for extra clearification as all signals 
-- are defined in top entity part

-- signals for energy monitor
signal decrease   : std_logic;
signal increase   : std_logic;
signal run_now    : std_logic;

------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
desired_temp  <= sw(3 downto 0);
vacation_temp <= sw(7 downto 4);

-- here the instances begin

inst1: hex_mux port map(
		 desired_temp,
		 vacation_temp,
		 vacation_mode,
		 mux_temp
		 );
		 		
inst2: Inverter port map(
		 pb_n(3),pb_n(2),pb_n(1),pb_n(0),
		 vacation_mode,MC_test_mode,window_open,door_open
		 );
		 
inst3: HVAC port map(
		 HVAC_SIM, clk_in,
		 run_now,
		 increase,decrease,
		 current_temp
		 );
		 
		 

inst4: Compx4 port map(
		 mux_temp,
		 current_temp,
		 AGTB, AEQB, ALTB
		 );
		 
inst5: SevenSegment port map(
		 mux_temp,
		 mt_7seg
		 );
		 
inst6: SevenSegment port map(
		 current_temp,
		 ct_7seg
		 );

inst7: segment7_mux port map(
		 clk_in,
		 mt_7seg, ct_7seg,
		 seg7_data,
		 seg7_char2,
		 seg7_char1
		 );

inst8: Tester port map(
		 MC_test_mode,
		 AEQB,AGTB,ALTB,
		 desired_temp,
		 current_temp,
		 leds(6)
		 );

inst9: Energy_Monitor port map(
		 AGTB,	    		  	 
		 AEQB,	   		 
		 ALTB,		   		
		 vacation_mode, 	 
		 MC_test_mode, 	     
	    window_open,        
		 door_open,         
		 leds(0),		      
		 leds(1),           
		 leds(2),			 	 
		 leds(3),		        
		 leds(4),	
		 leds(5), 
		 leds(7),	
		 decrease,
		 increase,			  
		 run_now			   
		 );


------------------------------------------------------------------
 HVAC_temp <= current_temp;  -- used for simulations only. Comment out for FPGA download compiles.	
------------------------------------------------------------------

end design;

