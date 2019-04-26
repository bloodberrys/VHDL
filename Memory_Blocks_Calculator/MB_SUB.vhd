library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MB_SUB is
port( datain : in std_logic_vector(3 downto 0);
		datain2 : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		dataout : out std_logic_vector(4 downto 0));
end entity;

architecture SUB of MB_SUB is
begin
process (clk)
begin
	if clk'event and clk ='1' then
	if datain < datain2 then
		dataout <= "00000";
	else
		dataout <= std_logic_vector('0'& unsigned(datain) - unsigned(datain2));
	end if;
	end if;
end process;
end architecture;
