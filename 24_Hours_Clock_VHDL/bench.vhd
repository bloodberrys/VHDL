library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity bench is
end entity;
 
architecture sim of bench is
 
    -- We're slowing down the clock to speed up simulation time
    constant frequency : integer := 10; -- 10 Hz
    constant periode_waktu      : time := 1000 ms / frequency;
 
    signal clk     : std_logic := '1';
    signal reset   : std_logic := '0';
    signal detik : integer;
    signal menit : integer;
    signal jam   : integer;
 
begin
 
    -- The Device Under Test (DUT)
    i_Timer : entity work.jam_digital(rtl)
    generic map(frequency => frequency)
    port map (
        clk     => clk,
        reset    => reset,
        detik => detik,
        menit => menit,
        jam   => jam);
 
    -- Process for generating the clock
    clk <= not clk after periode_waktu / 2;
 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
 
        -- Take the DUT out of reset
        reset <= '1';
 
        wait;
    end process;
 
end architecture;
