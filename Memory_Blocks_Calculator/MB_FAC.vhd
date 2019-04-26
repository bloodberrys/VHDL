LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MB_FAC IS
 PORT( nilai : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
   CLK :  IN  STD_LOGIC;
   dataout :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
END MB_FAC;

ARCHITECTURE FAC OF MB_FAC IS
 SIGNAL jumlah :  STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000001";
 SIGNAL hitung: STD_LOGIC_VECTOR(3 DOWNTO 0):= "0010";

 
 BEGIN
  PROCESS 
  BEGIN
   WAIT UNTIL CLK = '1' AND CLK'EVENT;
   IF nilai < "0110" THEN
    IF hitung <= nilai THEN
     jumlah <= jumlah(4 DOWNTO 0)*hitung(2 DOWNTO 0);
     hitung <= hitung + 1;
    END IF;
   ELSE jumlah <= "00000000";
   END IF;
   dataout <= jumlah;
  END PROCESS;
  
END FAC;