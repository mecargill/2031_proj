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

		fn_bris              : in brightness_array;
		clk12MHz             : in std_logic;
		funcs                : in func_array;
		
		
		brightnesses         : buffer brightness_array
		
		 );
end func_gen;


architecture a of func_gen is
	signal simple_count         : std_logic_vector(23 downto 0); --2^24 * 83.3ns = 1.398s max period
	
	constant period             : std_logic_vector(23 downto 0) := x"FFFFFF";--the period is this as a number times the clock pd, 1/12million = 83.3 ns
	--used matlab
	constant sine_wave : fn_LUT_type := (
    "0100000", "0100011", "0100110", "0101001", "0101100", "0101111", "0110001", "0110100",
	 "0110110", "0111000", "0111010", "0111100", "0111101", "0111110", "0111111", "0111111",
	 "1000000", "0111111", "0111111", "0111110", "0111101", "0111100", "0111010", "0111000",
	 "0110110", "0110100", "0110001", "0101111", "0101100", "0101001", "0100110", "0100011",
	 "0100000", "0011100", "0011001", "0010110", "0010011", "0010000", "0001110", "0001011",
	 "0001001", "0000111", "0000101", "0000011", "0000010", "0000001", "0000000", "0000000",
	 "0000000", "0000000", "0000000", "0000001", "0000010", "0000011", "0000101", "0000111",
	 "0001001", "0001011", "0001110", "0010000", "0010011", "0010110", "0011001", "0011100"
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
							--take let 6 bits as index to sine_wave, mult by input bri, then divide by 2^6, the current max val of sine_wave
							--only right 6 bits should be nonzero
							brightnesses(i) <= std_logic_vector(unsigned(sine_wave(to_integer(unsigned(simple_count) srl 18)) * fn_bris(i)) srl 6)(5 downto 0); 
						
						when linear =>
							--right 18 bits being 0 happens once every 2^18 cycles => if you fade from 0 to max it takes 2^18 * 2^6 * 83.3ns = 1.398s, which should be slow enough
							if ((simple_count and "111111000000000000000000") = simple_count) and brightnesses(i) < fn_bris(i) then
								brightnesses(i) <= brightnesses(i) + 1;
							elsif
								((simple_count and "111111000000000000000000") = simple_count) and brightnesses(i) > fn_bris(i) then
									brightnesses(i) <= brightnesses(i) - 1;
							end if;
							
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