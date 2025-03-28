library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;
use work.led_types.all;

--This device takes in a brightness array (2d) and takes care of LED control, no gamma correction yet
entity pulse_gen is
	
	port(
		 brightnesses    : in  brightness_array;
		 clk12MHz        : in  std_logic;
		 resetn          : in  std_logic;
		 
		 leds            : out std_logic_vector(9 downto 0)
		 );
end pulse_gen;

--it seems like maybe the clock stops on reset because leds just hold value on reset
architecture a of pulse_gen is
	signal count : std_logic_vector(5 downto 0);
begin
	process(clk12MHz)
	
	begin
		if rising_edge(clk12MHz) then
			for i in 0 to 9 loop
				if count = "111111" then
					--pass
				elsif count = brightnesses(i) then
					leds(i) <= '0';
				elsif count = "000000" then
					leds(i) <= '1';
				end if;
			end loop;
			count <= count + 1;		
		end if;
		
	end process;

end a;
