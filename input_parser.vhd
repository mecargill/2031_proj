library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;

use work.led_types.all;

entity input_parser is
		
port(
    cs0         : in  std_logic; --this io address tells brightness and a bit mask
	 cs1			 : in  std_logic; --this io address tells the pattern/fn and params 
	 cs2			 : in  std_logic;
    write_en    : in  std_logic;
    resetn      : in  std_logic;
    clk12MHz    : in  std_logic;
	 io_data     : in  std_logic_vector(15 downto 0);
	 
    brightnesses  : out brightness_array--10 brightnesses
    );
end input_parser;


architecture a of input_parser is
	--address 0x20
	signal startBr		: std_logic_vector(5 downto 0); -- start brightness (the min)
	signal bitmask    : std_logic_vector(9 downto 0); -- which LEDs are being set (others go off), last 10 bits

begin
	
	
	brightnesses <= (others => "000000");
end a;

