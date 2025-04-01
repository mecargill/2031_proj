library ieee;


use ieee.std_logic_1164.all;


package led_types is
	type brightness_array is array(9 downto 0) of std_logic_vector(5 downto 0);
	type time_array is array (9 downto 0) of std_logic_vector(7 downto 0);
	type func_type is (step, square, sine, linear);
	type func_array is array(9 downto 0) of func_type;
	
	type input_conversion_type is array(0 to 15) of std_logic_vector(5 downto 0);
	type fn_LUT_type is array (0 to 63) of std_logic_vector(6 downto 0);
	type gamma_LUT_type is array(0 to 63) of std_logic_vector(7 downto 0);
end package;