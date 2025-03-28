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
			cs0         : in  std_logic; --this io address tells brightness and a bit mask
			cs1			 : in  std_logic; --this io address tells the pattern/fn and params 
			cs2			 : in  std_logic;
			write_en    : in  std_logic;
			resetn      : in  std_logic;
			clk12MHz    : in  std_logic;
			io_data     : in  std_logic_vector(15 downto 0);

			
			end_or_max_bris     : out brightness_array; --sorry for mixing camel case with snake case :(
			spans        : out brightness_array;
			pds          : out time_array; -- 64 samples is probably good for like 10 to 20 seconds, this goes to 1024 so we can go up to 10s if we want to keep 0.01s res
			funcs        : out func_array
      );
	end component;
	
	component func_gen
		port(
			
			end_or_max_bris      : in brightness_array;
			spans         : in brightness_array;
			pds          : in time_array; 
			clk12MHz     : in std_logic;
			funcs         : in func_array;
			
			clk_count    : in std_logic_vector(5 downto 0);

			brightnesses : out brightness_array
		);
	end component;

	component pulse_gen
		port(
			brightnesses    : in  brightness_array;
			clk12MHz        : in  std_logic;
			resetn          : in  std_logic;
			
			clk_count       : out std_logic_vector(5 downto 0);

			leds            : out std_logic_vector(9 downto 0)
		);
	end component;
	--intermediary signals.. are these necessary? I think so but not sure

	
	signal end_or_max_bris        : brightness_array;
	signal spans           : brightness_array;
	signal pds             : time_array;
	signal funcs           : func_array;
	
	signal clk_count       : std_logic_vector(5 downto 0);
	
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

			
			end_or_max_bris => end_or_max_bris,
			spans => spans,
			pds => pds,
			funcs => funcs
		);
		
	comp2: func_gen
		port map(
	
			end_or_max_bris => end_or_max_bris,
			spans => spans,
			pds => pds,
			clk12MHz => clk12MHz,
			funcs => funcs,
			
			clk_count => clk_count,
	
			brightnesses => brightnesses
		);
		
	comp3: pulse_gen
		port map(
			brightnesses => brightnesses,
			clk12MHz => clk12MHz,
			resetn => resetn,
			
			clk_count => clk_count,
			
			leds => leds
		);


end a;

