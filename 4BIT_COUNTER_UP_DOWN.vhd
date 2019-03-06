-- ===================================================================.
--     THIS PROGRAM WAS CREATED BY ALFIAN FIRMANSYAH                  |
--     THIS VHDL PROGRAM HAS A COPYRIGHT AS WELL                      |
--     IF YOU FORCE TO COPY OR USE THIS PROGRAM WITHOUT MY PERMISSION |
--     YOU WILL BE OKAY	:)                                            | 
-- ==================================================================='

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity up_down_counter is
port(
clk : in std_logic;
COUNTER_UP: OUT std_logic_vector(3 downto 0);
COUNTER_DOWN: OUT std_logic_vector(3 downto 0);
load: in std_logic;  --load 0 untuk down-counter, load 1 untuk up-counter
reset: in std_logic); --untuk reset
end entity;


architecture up_down_counter of up_down_counter is
signal output_up: std_logic_vector(3 downto 0) := "0000";
signal output_down: std_logic_vector(3 downto 0) := "0000";
signal hitung: std_logic_vector(3 downto 0) := "0000";
begin
rising :process(clk,load,reset) is

begin

if rising_edge(clk) and load = '0' and reset = '0' then    --load 0 maka down counter
	hitung <= hitung - 0001;	   --yaitu bakalan decrement 1 terus menerus tiap clock pulsenya
	output_down <= hitung;		   --save ke variable signal
elsif rising_edge(clk) and load = '1'  and reset = '0' then --load 1 maka up counter
	hitung <= hitung + 0001;	   --yaitu bakalan increment 1 terus menerus tiap clock pulsenya
	output_up <= hitung;		   --save ke variable signal
elsif reset = '1' and (load = '0' or load = '1') then
	hitung <= "0000";
	output_up <= hitung;
	output_down <= hitung;
end if;
end process;
COUNTER_UP <= output_up;		   --assign signal ke variable output entity
COUNTER_DOWN <= output_down;		   --assign signal ke variable output entity
end architecture;



      	

	
	
