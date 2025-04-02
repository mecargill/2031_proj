library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
	signal count  : std_logic_vector(7 downto 0);
	
	--this uses a gamma of 2, used matlab to calculate
	constant gamma_adj : gamma_LUT_type := (
		"00000000",	"00000000",	"00000000",	"00000000",	"00000001",	"00000001",	"00000010",	"00000011",
		"00000100",	"00000101",	"00000110",	"00000111",	"00001001",	"00001010",	"00001100",	"00001110",
		"00010000",	"00010010",	"00010100",	"00010111",	"00011001",	"00011100",	"00011111",	"00100001",
		"00100101",	"00101000",	"00101011",	"00101110",	"00110010",	"00110110",	"00111001",	"00111101",
		"01000001",	"01000101",	"01001010",	"01001110",	"01010011",	"01010111",	"01011100",	"01100001",
		"01100110",	"01101100",	"01110001",	"01110110",	"01111100",	"10000010",	"10000111",	"10001101",
		"10010100",	"10011010",	"10100000",	"10100111",	"10101101", "10110100",	"10111011",	"11000010",
		"11001001",	"11010000",	"11011000",	"11011111",	"11100111",	"11101111",	"11110110",	"11111111"
	);
begin
	process(clk12MHz, resetn)
	
	begin
		if resetn = '0' then
			leds <= "0000000000";
		elsif rising_edge(clk12MHz) then
			for i in 0 to 9 loop
				if count < gamma_adj(to_integer(unsigned(brightnesses(i)))) then
					leds(i) <= '1';
				else
					leds(i) <= '0';
				end if;
			end loop;
			count <= count + 1;		
		end if;
		
	end process;
	
end a;
