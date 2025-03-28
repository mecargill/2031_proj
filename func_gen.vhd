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
		sup_count    : in std_logic_vector(5 downto 0);
		startBr      : in std_logic_vector(5 downto 0);
		span         : in std_logic_vector(5 downto 0);
		pd           : in std_logic_vector(9 downto 0);
		clk12MHz     : in std_logic;
		func         : in func_type;
		
		brightnesses : out brightness_array;
		
		 );
end func_gen;


architecture a of func_gen is
	
begin
	

end a;