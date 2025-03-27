library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
use lpm.lpm_components.all;

use work.led_types.all;

entity ledcontroller is
port(
    cs0         : in  std_logic; --this io address tells brightness and a bit mask
	 cs1			 : in  std_logic; --this io address tells the pattern/fn and params 
	 cs2			 : in  std_logic;
    write_en    : in  std_logic;
    resetn      : in  std_logic;
    clk12MHz    : in  std_logic;
    leds        : out std_logic_vector(9 downto 0);
    io_data     : in  std_logic_vector(15 downto 0)
    );
end ledcontroller;


architecture a of ledcontroller is
	
	component input_parser
		port(
      cs0           : in  std_logic; --this io address tells brightness and a bit mask
	   cs1			  : in  std_logic; --this io address tells the pattern/fn and params 
	   cs2		     : in  std_logic;
      write_en      : in  std_logic;
      resetn        : in  std_logic;
      clk12MHz      : in  std_logic;
	   io_data       : in  std_logic_vector(15 downto 0);
	 
      brightnesses  : out brightness_array--10 brightnesses
      );
	end component;

	component pulse_gen
		port(
	   brightnesses     : in brightness_array;
		clk12MHz         : in std_logic;
	 
      leds             : out std_logic_vector(9 downto 0)--determined by brightness bits
      );
	end component;
	
	signal brightnesses : brightness_array;

begin
	comp1: input_parser
		port map(
			cs0 => cs0,
			cs1 => cs1,
			cs2 => cs2,
			write_en => write_en,
			resetn => resetn,
			clk12MHz => clk12MHz,
			io_data => io_data,
			brightnesses => brightnesses
		);
		
	comp2: pulse_gen
		port map(
			brightnesses => brightnesses,
			clk12MHz => clk12MHz,
			leds => leds
		);


end a;

