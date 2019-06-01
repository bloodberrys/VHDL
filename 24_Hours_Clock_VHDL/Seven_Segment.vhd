LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Seven_Segment IS
PORT ( NILAI : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 KELUAR : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
		 
END ENTITY;

ARCHITECTURE SEV OF Seven_Segment IS
BEGIN
PROCESS (NILAI)
BEGIN
CASE NILAI IS
--      --A--
--     |     |
--     F     B
--     |     |
--     |- G -|
--     E     C
--     |     | 
--     |     |
--      ---D--
--  BITNYA = ABCDEFG;

		WHEN "0000" => KELUAR <= "1111110"; --0
		WHEN "0001" => KELUAR <= "0110000"; --1
		WHEN "0010" => KELUAR <= "1101101"; --2
		WHEN "0011" => KELUAR <= "1111001"; --3
		WHEN "0100" => KELUAR <= "0110011"; --4
		WHEN "0101" => KELUAR <= "1011011"; --5
		WHEN "0110" => KELUAR <= "1011111"; --6
		WHEN "0111" => KELUAR <= "1110000"; --7
		WHEN "1000" => KELUAR <= "1111111"; --8
		WHEN "1001" => KELUAR <= "1111011"; --9
		WHEN "1010" => KELUAR <= "1110111"; --A
		WHEN "1011" => KELUAR <= "1111111";--B
		WHEN "1100" => KELUAR <= "1001110";--C
		WHEN "1101" => KELUAR <= "1111110";--D
		WHEN "1110" => KELUAR <= "1001111";--E
		WHEN "1111" => KELUAR <= "1000111";--F
		WHEN OTHERS => KELUAR <= "0000000";--sisanya salah dong
END CASE;
END PROCESS;
END ARCHITECTURE;
