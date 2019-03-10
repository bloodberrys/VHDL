-- ===================================================================.
--     THIS PROGRAM WAS CREATED BY ALFIAN FIRMANSYAH                  |
--     DOWN COUNTER WITH OUTPUT LED SEVEN SEGMENT                     |
--     IF YOU FORCE TO COPY OR USE THIS PROGRAM WITHOUT MY PERMISSION |
--     YOU WILL BE OKAY	:)                                            | 
-- ==================================================================='

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity down_counter is
port(
clk : in std_logic;
COUNTER_DOWN: OUT std_logic_vector(2 downto 0);
seven_segment : OUT std_logic_vector(6 downto 0);
reset: in std_logic); --untuk reset
end entity;


architecture down_counter of down_counter is
signal output_down: std_logic_vector(2 downto 0) := "000";
signal hitung: std_logic_vector(2 downto 0) := "000";
signal s7: std_logic_vector(6 downto 0) := "1111110";  --seven segment 0
begin
rising :process(clk,reset) is

begin

if rising_edge(clk) and reset = '0' then    -- input reset harus di set ke 0 maka down counter baru akan berjalan
	hitung <= hitung - 001;	   --yaitu bakalan decrement 1 terus menerus tiap clock pulsenya
	output_down <= hitung;		   --save ke variable signal
	

	case output_down is
        when "000" => s7 <= "1111110";		--konversi ke output seven-segment
        when "001" => s7 <= "0110000";
        when "010" => s7 <= "1101101";
        when "011" => s7 <= "1111001";
	when "100" => s7 <= "0110011";
	when "101" => s7 <= "1011011";
	when "110" => s7 <= "1011111";
	when "111" => s7 <= "1110000";
        when others => report "unreachable" severity failure;
    	end case;

elsif rising_edge(clk) and reset = '1' then
	hitung <= "000";
	output_down <= hitung;
	s7 <= "1111110";  --jadi 0 seven segmentnya
	
end if;



end process;
COUNTER_DOWN <= output_down;		   --assign signal ke variable output entity
seven_segment <= s7;		-- assign signal ke seven segment
end architecture;


--NOTE: hasil seven segment akan mengalami delay selama 1 grid picosecond karena terdapat propagation delay.
      	

	
	
