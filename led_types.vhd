library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all;

package led_types is
	type brightness_array is array(9 downto 0) of std_logic_vector(5 downto 0);
	type time_array is array (9 downto 0) of std_logic_vector(7 downto 0);
	type func_type (linear, square, sine, sawtooth);
	type func_array is array(9 downto 0) of func_type;
end package;