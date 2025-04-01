library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;

use work.led_types.all;

--This device handles getting input from scomp
entity input_parser is
		
	port(
		 cs0         : in  std_logic; --this io address tells brightness and a bit mask
		 cs1			 : in  std_logic; --cs1 and cs2 are unused currently, but if we add more we can use them
		 cs2			 : in  std_logic;
		 write_en    : in  std_logic;
		 resetn      : in  std_logic;
		 clk12MHz    : in  std_logic;
		 io_data     : in  std_logic_vector(15 downto 0);
		 

		 g_adj_bris   : out brightness_array; --gamma adjusted brightnesses (6 bit) based on input bri(4 bit)
		 funcs        : out func_array        --which animation/function to apply
		 
		 );
end input_parser;


architecture a of input_parser is
	
	signal input_bri     : integer range 0 to 15; --this is not gamma adjusted, directly coming from command
	--LUT uses normal, top to bottom indexing, unlike the std logic vectors inside of it

	
	--These values were just put in as a guess. they weren't calculated. we should find a real model
	constant gamma_LUT   : gamma_adjustment_array := (
		"000000","000001","000010","000011",
		"000100","000101","000110","000111",
		"001000","001010","001100","001110",
		"001111","010000","011111","111111"
	);
	
begin
	--this process takes 0x20 commands
	process(cs0, resetn) 
		begin
		if resetn = '0' then
			--ensure they stay off after resetn assertion (there is also async reset in pulse gen)
			g_adj_bris <= (others => "000000");
			funcs <= (others => step);
			
		elsif rising_edge(cs0) and write_en = '1' then
		
			input_bri <= to_integer(unsigned(io_data(13 downto 10)));
			
			for i in 0 to 9 loop
				if io_data(i) = '1' then
					--assign func
					case io_data(15 downto 14) is
						when "00" =>
							funcs(i) <= step;
						when "01" =>
							funcs(i) <= square;
						when "10" =>
							funcs(i) <= sine;
						when "11" =>
							funcs(i) <= linear;
					end case;	
					--assign g_adj_bris
					g_adj_bris(i) <= gamma_LUT(input_bri);
					
				end if;
			end loop;
		end if;
	end process;
	
	
		
end a;
