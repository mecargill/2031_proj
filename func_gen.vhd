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

		g_adj_bris           : in brightness_array;
		clk12MHz             : in std_logic;
		funcs                : in func_array;
		
		
		brightnesses         : out brightness_array
		
		 );
end func_gen;


architecture a of func_gen is
	signal simple_count         : std_logic_vector(23 downto 0); --2^24 * 83.3ns = 1.398s max period
	constant period             : std_logic_vector(23 downto 0) := x"FFFFFF";--the period is this as a number times the clock pd, 1/12million = 83.3 ns
	
begin

	process(clk12MHz)
	begin
		if rising_edge(clk12MHz) then
				for i in 0 to 9 loop
					case funcs(i) is 
					
						when step   =>
							brightnesses(i) <= g_adj_bris(i);
							
						when square =>
							--logical right shift for 50% duty cycle
							if unsigned(simple_count) <= (unsigned(period) srl 1) then
								brightnesses(i) <= g_adj_bris(i);
							else
								brightnesses(i) <= "000000"; 
							end if;
								
						when others =>
							brightnesses(i) <= g_adj_bris(i);
							
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