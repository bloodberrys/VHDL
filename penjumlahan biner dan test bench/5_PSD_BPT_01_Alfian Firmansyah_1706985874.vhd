LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FA_TESTBENCH IS
END ENTITY;

ARCHITECTURE FATB OF FA_TESTBENCH IS
SIGNAL INPUT1 : STD_LOGIC:='0';
SIGNAL INPUT2 : STD_LOGIC:='0';
SIGNAL CLK : STD_LOGIC;
SIGNAL OUTPUT : STD_LOGIC;
SIGNAL INPUTGEDE : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10010110";
SIGNAL INPUTGEDE2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00101110";
SIGNAL OUTPUTGEDE : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
JUMLAH: ENTITY WORK.PENJUMLAHANBINER(JUMLAHIN)
PORT MAP (
	INPUT1 => INPUT1,
	INPUT2 => INPUT2,
	CLK => CLK,
	output => output
	);

PROCESS IS
BEGIN
	CLK <='1';
	WAIT FOR 5 NS;
	CLK <='0';
	WAIT FOR 5 NS;
END PROCESS;

PROCESS
BEGIN
FOR I IN 0 TO 7 LOOP
	INPUT1 <= INPUTGEDE(I);
	INPUT2 <= INPUTGEDE2(I);
	WAIT FOR 10 NS;
	OUTPUTGEDE(i) <= OUTPUT;
	END LOOP;
	WAIT FOR 10 NS;
	WAIT;
END PROCESS;
END ARCHITECTURE;
	


