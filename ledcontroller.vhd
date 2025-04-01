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
    io_data     : in  std_logic_vector(15 downto 0);
	 
	 leds        : out std_logic_vector(9 downto 0)
    );
end ledcontroller;


architecture a of ledcontroller is
	
	component input_parser
		port(
			cs0          : in  std_logic; --this io address tells brightness and a bit mask
			cs1			 : in  std_logic; --this io address tells the pattern/fn and params 
			cs2			 : in  std_logic;
			write_en     : in  std_logic;
			resetn       : in  std_logic;
			clk12MHz     : in  std_logic;
			io_data      : in  std_logic_vector(15 downto 0);

			g_adj_bris   : out brightness_array; --gamma adjusted brightnesses (6 bit) based on input bri(4 bit)
		   funcs        : out func_array        --which animation/function to apply
			
      );
	end component;
	
	component func_gen
		port(
			
			g_adj_bris   : in brightness_array;
			clk12MHz     : in std_logic;
			funcs        : in func_array;
			
			brightnesses : out brightness_array
		);
	end component;

	component pulse_gen
		port(
			brightnesses : in  brightness_array;
			clk12MHz     : in  std_logic;
			resetn       : in  std_logic;

			leds         : out std_logic_vector(9 downto 0)
		);
	end component;


	
	signal g_adj_bris   : brightness_array;
	signal funcs        : func_array;
	
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

			
			g_adj_bris => g_adj_bris,
			funcs => funcs		
		);
		
	comp2: func_gen
		port map(
	
			g_adj_bris => g_adj_bris,
			clk12MHz => clk12MHz,
			funcs => funcs,
	
			brightnesses => brightnesses
		);
		
	comp3: pulse_gen
		port map(
			brightnesses => brightnesses,
			clk12MHz => clk12MHz,
			resetn => resetn,
			
			leds => leds
		);


end a;

