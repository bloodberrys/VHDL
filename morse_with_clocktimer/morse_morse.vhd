-- morse yang dibuat dengan bench timer 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity morse_code is
generic(frequency : integer);
port(
    clk     : in std_logic;
    reset    : in std_logic; 
    trigger_code : inout std_logic;	
    encapsulated : inout integer;
    huruf : inout integer);	
end entity;
 
architecture rtl of morse_code is
 
    signal satu_berdetik : integer;
	
begin

    process(clk) is

	
    begin
        if rising_edge(clk) then
 
            -- jika reset sama dengan 0
            if reset = '0' then
                satu_berdetik   <= 0;
                trigger_code <= '0';
                huruf <= 0;
		encapsulated <= 0;
            else
               
                if satu_berdetik = frequency - 1 then
                    satu_berdetik <= 0;
			if huruf = 0 then -- HURUF H
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 3 or encapsulated = 4 or  
					encapsulated = 6 or encapsulated = 7 or encapsulated = 9 or encapsulated = 10 then
					trigger_code <= '1';
					huruf<= 0;
					encapsulated <= encapsulated + 1;
				elsif encapsulated = 2 or encapsulated = 5 or encapsulated = 8 or encapsulated = 11 or encapsulated = 12 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;
				else
					trigger_code <= '0';
					encapsulated <= 0;  --reset encapsulated
					huruf <= huruf + 1;
				end if;
			elsif huruf = 1 then -- HURUF A
				
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 3 or encapsulated = 4 or encapsulated = 5 or encapsulated = 6 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif encapsulated = 2 or encapsulated = 7 or encapsulated = 8 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;
				else
					trigger_code <= '0';
					huruf <= huruf + 1; 
					encapsulated <= 0;
				end if;
			
			elsif huruf = 2 then -- HURUF I
				 --reset counter
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 3 or encapsulated = 4 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif encapsulated = 2 or encapsulated = 5 or encapsulated = 6 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;
				else
					trigger_code <= '0';
					encapsulated <= 0;
					huruf <= huruf + 1;
				end if;

			elsif huruf = 3 then  -- HURUF B
				encapsulated <= 0;
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 2 or encapsulated = 3 or encapsulated = 5 or encapsulated = 6 or encapsulated = 8 or encapsulated = 9 or encapsulated = 11 or encapsulated = 12 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif  encapsulated = 4 or encapsulated = 7 or encapsulated = 10 or encapsulated = 13 or encapsulated = 14 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;
				else
					trigger_code <= '0';
					huruf <= huruf + 1;
				end if;

			elsif huruf = 4 then  --HURUF A
				encapsulated <= 0;
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 3 or encapsulated = 4 or
					encapsulated = 5 or encapsulated = 6 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif encapsulated = 2 or encapsulated = 7 or encapsulated = 8 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;
				else
					trigger_code <= '0';
					huruf <= huruf + 1; 
				end if;
			
			elsif huruf = 5 then  --HURUF Y
				encapsulated <= 0;
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 2 or encapsulated = 3 or   
			 		 encapsulated = 5 or encapsulated = 6 or encapsulated = 8 or encapsulated = 9 or
					 encapsulated = 10 or encapsulated = 11 or encapsulated = 13 or encapsulated = 14 or encapsulated = 15 or encapsulated = 16 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif  encapsulated = 4 or encapsulated = 7 or encapsulated = 12 or encapsulated = 17 or encapsulated = 18 then
				        trigger_code <= '0';
					encapsulated <= encapsulated + 1;  
				else
					trigger_code <= '0';
					encapsulated <= 0;
					huruf <= huruf + 1;
				end if;
			
			elsif huruf = 6 then  --HURUF U
				encapsulated <= 0;
				if encapsulated = 0 or encapsulated = 1 or encapsulated = 3 or encapsulated = 4 or
					encapsulated = 6 or encapsulated = 7 or encapsulated = 8 or encapsulated = 9 then
					trigger_code <= '1';
					encapsulated <= encapsulated + 1;
				elsif encapsulated = 2 or encapsulated = 5 or encapsulated = 10 then
					trigger_code <= '0';
					encapsulated <= encapsulated + 1;  
				else
					trigger_code <= '0';
					huruf <= huruf + 1;
				end if;
			end if;
			
                else
                    satu_berdetik <= satu_berdetik + 1;
                end if;
 
            end if;
        end if;
    end process;
 
end architecture;
