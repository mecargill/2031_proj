library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; --gives signed + unsigned types (but is not actually iee standard)
use ieee.std_logic_unsigned.all; --overloads operations for std_logic types
use lpm.lpm_components.all;

use work.led_types.all;

--This device handles getting input from scomp
entity input_parser is
		
	port(
		 cs0         : in  std_logic; --this io address tells brightness and a bit mask
		 cs1			 : in  std_logic; --this io address tells the pattern/fn and params 
		 cs2			 : in  std_logic;
		 write_en    : in  std_logic;
		 resetn      : in  std_logic;
		 clk12MHz    : in  std_logic;
		 io_data     : in  std_logic_vector(15 downto 0);
		 
		 sup_count   : out std_logic_vector(5 downto 0); --a subcycle is 5.3 us. 64 samples stored so 2^6?
		 startBr     : out std_logic_vector(5 downto 0); --start brightness
		 span        : out std_logic_vector(5 downto 0);
		 pd          : out std_logic_vector(9 downto 0); -- 64 samples is probably good for like 10 to 20 seconds, this goes to 1024 so we can go up to 10s if we want to keep 0.01s res
		 func        : out func_type;
		 );
end input_parser;


architecture a of input_parser is
	--address 0x20
	

begin
	
	process(cs0, resetn)
	begin
		if resetn = '0' then
			brightnesses <= (others => "000000");
		elsif cs0 = '1' and write_en = '1' then
			for i in 0 to 9 loop
				if (io_data(i) = '1') then
					brightnesses(i) <= io_data(15 downto 10);
				end if;
			end loop;
		end if;
	end process;
	
	
	
	
end a;

