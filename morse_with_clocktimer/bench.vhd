library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity bench is
end entity;
 
architecture sim of bench is
 
    constant frequency : integer := 10; -- 10 Hz
    constant periode_waktu      : time := 500 ms / frequency;
 
    signal clk     : std_logic := '1';
    signal reset   : std_logic := '0';
  signal encapsulated : integer;
signal huruf	: integer;
signal trigger_code : std_logic;
 
begin
 
    -- ambil code asli
    i_Timer : entity work.morse_code(rtl)
    generic map(frequency => frequency)
    port map (
        clk     => clk,
        reset    => reset,
       encapsulated => encapsulated,
	huruf => huruf,
	trigger_code => trigger_code);
    -- Pembuatan waktunya
    clk <= not clk after periode_waktu / 2;
 
    -- sequence nya
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
 
        -- reset
        reset <= '1';
 
        wait;
    end process;
 
end architecture;
