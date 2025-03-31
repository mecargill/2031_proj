library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;
use work.led_types.all;

--This device takes in function parameters and updates the function param memory, then 
entity func_gen is
	
	port(	 

		end_or_max_bris      : in brightness_array;
		spans                : in brightness_array;
		pds                  : in time_array;
		clk12MHz             : in std_logic;
		funcs                : in func_array;
		
		clk_count            : in std_logic_vector(5 downto 0);--this is shared to not waste resources
		
		brightnesses         : out brightness_array
		
		 );
end func_gen;


architecture a of func_gen is

	--arbitrarily I picked 0.05s resolution and 64 samples. That leads to 16 bit pulse pd ct and 6 bit sample ct (one pulse pd is 5.3333us)
	
	signal pulse_pd_counts      : pulse_pd_count_array; --these are independent for ease of computation. If shared, would have to store start time anyways to handle diff pds
	signal sample_counts        : sample_count_array;
	signal pds_per_sample_nums	 : pulse_pd_count_array; --this could be 37500 at max pd
	
	signal simple_count         : std_logic_vector(23 downto 0);
	
begin
	
	process(clk12MHz)
	begin
		if rising_edge(clk12MHz) then
		
				for i in 0 to 9 loop
					--this case takes care of setting brightnesses based on sample counts
					case funcs(i) is 
						when step   =>
							brightnesses(i) <= end_or_max_bris(i);
							
						when square =>
							if simple_count < x"800000" then
								brightnesses(i) <= end_or_max_bris(i);
							else
								brightnesses(i) <= (end_or_max_bris(i) - spans(i)); --will this work?, it did!... maybe...
							end if;
								
						when others =>
							brightnesses(i) <= end_or_max_bris(i);
					end case;
					
					--t
					
				end loop;
				simple_count <= simple_count + 1;
		end if;
	end process;
	
	pds_per_sample_nums <= (others => "0000101101110000");
end a;