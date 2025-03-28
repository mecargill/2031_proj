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
		 

		 end_or_max_bris     : out brightness_array; --start brightness
		 spans        : out brightness_array; --span is the brightness span
		 pds          : out time_array; -- 64 samples is probably good for like 10 to 20 seconds, this goes to 1024 so we can go up to 10s if we want to keep 0.01s res
		 funcs        : out func_array
		 );
end input_parser;


architecture a of input_parser is
	signal curr_end_or_max_bri : std_logic_vector(5 downto 0);
	signal curr_span    : std_logic_vector(5 downto 0);
	signal curr_pd      : std_logic_vector(7 downto 0);
	signal curr_func    : func_type;
	
	signal sub_count    : std_logic_vector(2 downto 0);

begin
	
	process(cs0, resetn) --this process takes 0x20 address commands. These commands latch through the current func that is set by the 0x21 cmd
	begin
		if resetn = '0' then
			--setting to step and end bri 0 should make them off, then behave like original peripheral on reset (at 0x20)
			end_or_max_bris <= (others => "000000");
			funcs <= (others => step);
		elsif rising_edge(cs0) and write_en = '1' then
			--update with the data in current 0x20 cmd, and last 0x21 cmd data, updating on a 0x20 cmd edge
			for i in 0 to 9 loop
				if (io_data(i) = '1') then
					end_or_max_bris(i) <= io_data(15 downto 10);
					spans(i) <= curr_span;
					pds(i) <= curr_pd;
					funcs(i) <= curr_func;
				end if;
			end loop;
		
			
		end if;
	end process;
	
	process(cs1, resetn) --this process takes 0x21 address commands. It holds the last given vals and passes to any cmds given to 0x20
	begin
		if resetn = '0' then
			curr_func <= step;
		elsif rising_edge(cs1) and write_en = '1' then
			--grab func
			case io_data(15 downto 14) is
				when "00" =>
					curr_func <= step;
				when "01" =>
					curr_func <= square;
				when others =>
					curr_func <= square; --in the future, we can add more here
			end case;
			--grab span and pd
			
			curr_span <= io_data(13 downto 8);
			curr_pd <= io_data(7 downto 0);
			
			
		end if;
	end process;
	
	
end a;

