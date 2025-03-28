library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all;

package led_types is
	type brightness_array is array(9 downto 0) of std_logic_vector(5 downto 0);
	type time_array is array (9 downto 0) of std_logic_vector(7 downto 0);
	type func_type is (linear, square, sine, step);
	type func_array is array(9 downto 0) of func_type;
	
	type pulse_pd_count_array is array(9 downto 0) of std_logic_vector(15 downto 0); 
	--if we want 0.05s resolution of pd, with 2^8 options, and 2^6 samples, 
	--thats max samp time of 4*0.05 = 0.2. 0.2/5.333us is 3500 max pulse pd count. So we need 16 bits.
	
	type sample_count_array is array(9 downto 0) of std_logic_vector(5 downto 0); 
	--needs to go to how many samples... 64 should be mroe than enough
end package;