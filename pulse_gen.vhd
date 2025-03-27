library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;
use work.led_types.all;

entity pulse_gen is
	
port(
	 brightnesses    : in  brightness_array;
	 clk12MHz        : in  std_logic;
	 
    leds            : out std_logic_vector(9 downto 0)
    );
end pulse_gen;


architecture a of pulse_gen is

begin
	leds <= "0000000000";

end a;
