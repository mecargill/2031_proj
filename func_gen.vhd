library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;
use work.led_types.all;

--This device takes in function parameters and outputs brightnesses to pulse gen
entity func_gen is
	
	port(	 

		fn_bris           : in brightness_array;
		clk12MHz             : in std_logic;
		funcs                : in func_array;
		
		
		brightnesses         : out brightness_array
		
		 );
end func_gen;


architecture a of func_gen is
	signal simple_count         : std_logic_vector(23 downto 0); --2^24 * 83.3ns = 1.398s max period
	
	constant period             : std_logic_vector(23 downto 0) := x"FFFFFF";--the period is this as a number times the clock pd, 1/12million = 83.3 ns
	--used matlab
	constant sine_wave : fn_LUT_type := (
    "011111",   "100010",   "100101",  "101000",   "101011",  "101110",   "110001",   "110011",
    "110101",   "110111",   "111001",  "111011",   "111100",  "111101",   "111110",   "111110",
    "111111",   "111110",   "111110",  "111101",   "111100",  "111011",   "111001",   "110111",
    "110101",   "110011",   "110001",  "101110",   "101011",  "101000",   "100101",   "100010",
    "011111",   "011100",   "011001",  "010110",   "010011",  "010000",   "001101",   "001011",
    "001001",   "000111",   "000101",  "000011",   "000010",  "000001",   "000000",   "000000",
    "000000",   "000000",   "000000",  "000001",   "000010",  "000011",   "000101",   "000111",
    "001001",   "001011",   "001101",  "010000",   "010011",  "010110",   "011001",   "011100"
	);

begin

	process(clk12MHz)
	begin
		if rising_edge(clk12MHz) then
				for i in 0 to 9 loop
					case funcs(i) is 
					
						when step   =>
							brightnesses(i) <= fn_bris(i);
							
						when square =>
							--logical right shift for 50% duty cycle
							if unsigned(simple_count) <= (unsigned(period) srl 1) then
								brightnesses(i) <= fn_bris(i);
							else
								brightnesses(i) <= "000000"; 
							end if;
						when sine =>
							brightnesses(i) <= sine_wave(to_integer(unsigned(simple_count) srl 18)); --this will not adjust with period or brightness
						when linear =>
							--could be a bit hard with just one count
							brightnesses(i) <= fn_bris(i);
							
					end case;
				end loop;
				
				
				
				if simple_count = period then
					simple_count <= x"000000";
				else
					simple_count <= simple_count + 1;
				end if;
		end if;
	end process;
	
	
end a;