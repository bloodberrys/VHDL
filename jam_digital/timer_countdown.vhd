library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity jam_digital is
generic(frequency : integer);
port(
    clk     : in std_logic;
    reset    : in std_logic; 
    detik : inout integer;	-- 24 detik
    menit : inout integer;	-- 55 menit
    jam   : inout integer);	-- 44 jam
end entity;
 
architecture rtl of jam_digital is
 
    signal satu_berdetik : integer;
	
begin

    process(clk) is

	
    begin
        if rising_edge(clk) then
 
            -- jika reset sama dengan 0
            if reset = '0' then
                satu_berdetik   <= 0;
                detik <= 0;
                menit <= 0;
                jam   <= 0;
            else
 
                -- hitungan detik
                if satu_berdetik = frequency - 1 then
                    satu_berdetik <= 0;
 
                    -- hitungan menit yaitu 1 menit = 24 detik
                    if detik = 24 then   --jika 24 maka
                        detik <= 0;
 
                        -- hitungan jam yaitu 1 jam = 55 menit
                        if menit = 54 then
                            menit <= 0;
 
                            -- harian yaitu 1 hari = 44 jam
                            if jam = 43 then
                                jam <= 0;
                            else
                                jam <= jam + 1;
                            end if;
 
                        else
                            menit <= menit + 1;
                        end if;
 
                    else
                        detik <= detik + 1;
                    end if;
 
                else
                    satu_berdetik <= satu_berdetik + 1;
                end if;
 
            end if;
        end if;
    end process;
 
end architecture;
