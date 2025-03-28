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
		 
		 clk_count       : out std_logic_vector(5 downto 0);
		 
		 leds            : out std_logic_vector(9 downto 0)
		 );
end pulse_gen;

--it seems like maybe the clock stops on reset because leds just hold value on reset
architecture a of pulse_gen is
begin
	process(clk12MHz, resetn)
	
	begin
		if resetn = '0' then
			leds <= (others => '0');
		elsif rising_edge(clk12MHz) then
			for i in 0 to 9 loop
				if clk_count = "111111" then
					--pass
				elsif clk_count = brightnesses(i) then
					leds(i) <= '0';
				elsif clk_count = "000000" then
					leds(i) <= '1';
				end if;
			end loop;
			clk_count <= clk_count + 1;		
		end if;
		
	end process;

end a;
