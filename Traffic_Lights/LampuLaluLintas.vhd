library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity LampuLaluLintas is
	port
	(
		LIGHTS_1,LIGHTS_2,LIGHTS_3,LIGHTS_4 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0); --LAMPU UNTUK KENDARAAN hIJAU,KUNING,MERAH
		CROSS1,CROSS2,CROSS3,CROSS4 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --LAMPU PENYEBRANGAN
		SEVSEG11,SEVSEG12,SEVSEG21,SEVSEG22,SEVSEG31,SEVSEG32,SEVSEG41,SEVSEG42 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);--SEVENSEGMENTNYA
		START : IN STD_LOGIC := '0'; --SAKLAR ON OFF SEMUA LAMPU (UNTUK SETTING MANUAL)
		CLOCKING : IN STD_LOGIC;--UNTUK NGATUR WAKTU DI QUARTUS
		LOAD : IN STD_LOGIC;
		SELEKSI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		NILAI : IN INTEGER RANGE 0 TO 256;
		E_SELECT : IN STD_LOGIC
	);
end entity;


architecture State of LampuLaluLintas is
-- Build an enumerated type for the state machine
	type keadaan is (mati,zebra1,zebra2,zebra3,zebra4,zebrawait,k_reset11,
	kuning1_1,hijau1,h1_reset,K_RESET12,kuning1_2, K_RESET21,kuning2_1, H2_RESET,hijau2,K_RESET22,kuning2_2,K_RESET31, kuning3_1, H3_RESET,hijau3,K_RESET32,
	kuning3_2, K_RESET41, H4_RESET,K_RESET42,	kuning4_1, hijau4, kuning4_2);
	--mati = keadaan mati; 
	--zebracross = nyebrang; 
	--kuningx_1 = kuning pertama lampu x; 
	--hijau1 = lampu x jadi hijau;
	--kuningx_2 = lampu x kuning kedua;
	SIGNAL COUNT1SIG : INTEGER RANGE 0 TO 256;
	SIGNAL COUNT2SIG : INTEGER RANGE 0 TO 256;
	SIGNAL COUNT3SIG : INTEGER RANGE -0TO 256 ;
	SIGNAL COUNT4SIG :  INTEGER RANGE 0 TO 256;
	SIGNAL COUNT : INTEGER RANGE 0 TO 256;
	SIGNAL state,nextstate : keadaan;--signal untuk state di flipflop
	SIGNAL ADDRESS : std_logic_vector(4 downto 0); --SIGNAL UNTUK AKSES MEMORI
	SIGNAL DATAMASUK : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COUNTUNSIGNED1 : STD_LOGIC_VECTOR(7 DOWNTO 0);		--mengakses counter			
	SIGNAL COUNTUNSIGNED2 : STD_LOGIC_VECTOR(7 DOWNTO 0);		--mengakses counter	
	SIGNAL COUNTUNSIGNED3 : STD_LOGIC_VECTOR(7 DOWNTO 0);		--mengakses counter			
	SIGNAL COUNTUNSIGNED4 : STD_LOGIC_VECTOR(7 DOWNTO 0);		--mengakses counter
	SIGNAL COUNTKUNINGUNSIGNED1 : STD_LOGIC_VECTOR(7 DOWNTO 0);--mengakses counter
	SIGNAL COUNTKUNINGUNSIGNED2 : STD_LOGIC_VECTOR(7 DOWNTO 0);--mengakses counter
	SIGNAL COUNTKUNINGUNSIGNED3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COUNTKUNINGUNSIGNED4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL countzebraunsigned : STD_LOGIC_VECTOR(7 DOWNTO 0) := "01100000";
	SIGNAL dataregisterunsigned : unsigned(7 DOWNTO 0);
	SIGNAL WRITEDATA : STD_LOGIC; --UNTUK MEWRITE DATA
	SIGNAL DATAREGISTER : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COUNTZEBRA : INTEGER RANGE 0 TO 256 := 60;
	SIGNAL COUNTKUNING1 : INTEGER RANGE 0 TO 5 := 5;
	SIGNAL COUNTKUNING2 : INTEGER RANGE 0 TO 5 := 5;
	SIGNAL COUNTKUNING3 : INTEGER RANGE 0 TO 5 := 5;
	SIGNAL COUNTKUNING4 : INTEGER RANGE 0 TO 5 := 5;
	SIGNAL ENABLEZEBRA,ENABLE1,ENABLE2,ENABLE3,ENABLE4 : STD_LOGIC;
	SIGNAL ENABLEKUNING1,ENABLEKUNING2,ENABLEKUNING3,ENABLEKUNING4 : STD_LOGIC;
	SIGNAL RESET,reset1,RESET2,RESET3,RESET4 : STD_LOGIC;
		
	COMPONENT COUNTER --UNTUK COUNTER
	PORT ( ENABLER : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 CLOCK : IN STD_LOGIC;
		 ANGKA : IN INTEGER RANGE -2 TO 256;
		 OUTPUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;	
	
	COMPONENT SEG7 --UNTUK SEVEN SEGMENT
	PORT ( ENABLER : IN STD_LOGIC;
				  NILAI : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		        KELUAR : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END component;
		
	begin
	COUNTERZEBRA : COUNTER PORT MAP(ENABLEZEBRA,RESET,CLOCKING,COUNTZEBRA,COUNTZEBRAUNSIGNED); --MEMBUAT COUNTER UNTK ZEBRA CROSS
	COUNTERKUNING1 : COUNTER PORT MAP (ENABLEKUNING1,RESET1,CLOCKING,COUNTKUNING1,COUNTKUNINGUNSIGNED1); --MEMBUAT COUNTER UNTUK LAMPU KUNING
	COUNTERKUNING2 : COUNTER PORT MAP (ENABLEKUNING2,RESET2,CLOCKING,COUNTKUNING2,COUNTKUNINGUNSIGNED2); --MEMBUAT COUNTER UNTUK LAMPU KUNING
	COUNTERKUNING3 : COUNTER PORT MAP (ENABLEKUNING3,RESET3,CLOCKING,COUNTKUNING3,COUNTKUNINGUNSIGNED3); --MEMBUAT COUNTER UNTUK LAMPU KUNING
	COUNTERKUNING4 : COUNTER PORT MAP (ENABLEKUNING4,RESET4,CLOCKING,COUNTKUNING4,COUNTKUNINGUNSIGNED4); --MEMBUAT COUNTER UNTUK LAMPU KUNING
	COUNTERHIJAU1 : COUNTER PORT MAP (ENABLE1,RESET,CLOCKING,COUNT1SIG,COUNTUNSIGNED1); -- MEMBUAT COUNTER UNTUK HIJAU1
	COUNTERHIJAU2 : COUNTER PORT MAP (ENABLE2,RESET,CLOCKING,COUNT2SIG,COUNTUNSIGNED2); -- MEMBUAT COUNTER UNTUK HIJAU2
	COUNTERHIJAU3 : COUNTER PORT MAP (ENABLE3,RESET,CLOCKING,COUNT3SIG,COUNTUNSIGNED3); -- MEMBUAT COUNTER UNTUK HIJAU3
	COUNTERHIJAU4 : COUNTER PORT MAP (ENABLE4,RESET,CLOCKING,COUNT3SIG,COUNTUNSIGNED4); -- MEMBUAT COUNTER UNTUK HIJAU4
	SEVEN11		  : SEG7 PORT MAP (ENABLE1,COUNTUNSIGNED1(3 DOWNTO 0),SEVSEG11); -- MEMBUAT SEVENSEGMENT1.1
	SEVEN12		  : SEG7 PORT MAP (ENABLE1,COUNTUNSIGNED1(7 DOWNTO 4),SEVSEG12); -- MEMBUAT SEVENSEGMENT1.2
	SEVEN21		  : SEG7 PORT MAP (ENABLE2,COUNTUNSIGNED2(3 DOWNTO 0),SEVSEG21); -- MEMBUAT SEVENSEGMENT2.1
	SEVEN22		  : SEG7 PORT MAP (ENABLE2,COUNTUNSIGNED2(7 DOWNTO 4),SEVSEG22); -- MEMBUAT SEVENSEGMENT2.2
	SEVEN31		  : SEG7 PORT MAP (ENABLE3,COUNTUNSIGNED3(3 DOWNTO 0),SEVSEG31); -- MEMBUAT SEVENSEGMENT3.1
	SEVEN32		  : SEG7 PORT MAP (ENABLE3,COUNTUNSIGNED3(7 DOWNTO 4),SEVSEG32); -- MEMBUAT SEVENSEGMENT3.2
	SEVEN41		  : SEG7 PORT MAP (ENABLE4,COUNTUNSIGNED4(3 DOWNTO 0),SEVSEG41); -- MEMBUAT SEVENSEGMENT4.1
	SEVEN42		  : SEG7 PORT MAP (ENABLE4,COUNTUNSIGNED4(7 DOWNTO 4),SEVSEG42); -- MEMBUAT SEVENSEGMENT4.2
	dataregisterunsigned <= unsigned(dataregister);
	COUNT <= TO_INTEGER(DATAREGISTERUNSIGNED);
	DATAMASUK <= STD_LOGIC_VECTOR(UNSIGNED(TO_UNSIGNED(NILAI,8)));
	
	
		
	Ram32x8_inst : ENTITY WORK.Ram32x8 PORT MAP ( --PORTING RAM 1 PORT KE SINI
		address	 => ADDRESS,
		clock	 => CLOCKING,
		data	 => DATAMASUK,
		wren	 => WRITEDATA,
		q	 => DATAREGISTER
	);
	
	PROCESS 
	BEGIN
		WAIT UNTIL RISING_EDGE(CLOCKING);
		STATE <= NEXTSTATE;
	END PROCESS;
	
	PROCESS(STATE,START,COUNTZEBRAUNSIGNED,COUNTUNSIGNED1,COUNTUNSIGNED2,COUNTUNSIGNED3,COUNTUNSIGNED4,COUNTKUNINGUNSIGNED1,COUNTKUNINGUNSIGNED2,COUNTKUNINGUNSIGNED3,COUNTKUNINGUNSIGNED4)
	BEGIN
		CASE STATE IS
			WHEN mati =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSE
						NEXTSTATE <= ZEBRA1;
				END IF;

		when zebra1=>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSE
						NEXTSTATE <= ZEBRA2;
				END IF;
		when zebra2=>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSE
						NEXTSTATE <= ZEBRA3;
				END IF;
		when zebra3=>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSE
						NEXTSTATE <= ZEBRA4;
				END IF;
		when zebra4=>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSE
						NEXTSTATE <= ZEBRAWAIT;
				END IF;
		WHEN ZEBRAWAIT =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTZEBRAUNSIGNED = "00000000")  THEN
						NEXTSTATE <= k_reset11;
				ELSE
						NEXTSTATE <= ZEBRAWAIT;
				END IF;
		WHEN K_RESET11 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING1_1;
				END IF;
		WHEN KUNING1_1 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED1 = "00000000") THEN
						NEXTSTATE <= H1_RESET;
				else
						nextstate <= KUNING1_1;
				END IF;
		WHEN H1_RESET =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= HIJAU1;
				END IF;
		WHEN HIJAU1 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTUNSIGNED1 = "00000000") THEN
						NEXTSTATE <= K_RESET12;
				else
						nextstate <= HIJAU1;
				END IF;
		WHEN K_RESET12 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING1_2;
				END IF;
		WHEN KUNING1_2 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED1 = "00000000") THEN
						NEXTSTATE <= K_RESET21;
				else
						nextstate <= KUNING1_2;
				END IF;
		WHEN K_RESET21 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING2_1;
				END IF;
		WHEN KUNING2_1 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED2 = "00000000") THEN
						NEXTSTATE <= H2_RESET;
				else
						nextstate <= KUNING2_1;
				END IF;
		WHEN H2_RESET =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= HIJAU2;
				END IF;
		WHEN HIJAU2 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTUNSIGNED2 = "00000000") THEN
						NEXTSTATE <= K_RESET22;
				else
						nextstate <= HIJAU2;
				END IF;
		WHEN K_RESET22 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING2_2;
				END IF;
		WHEN KUNING2_2 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED2 = "00000000") THEN
						NEXTSTATE <= K_RESET31;
				else
						nextstate <= KUNING2_2;
				END IF;
		WHEN K_RESET31 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING3_1;
				END IF;
		WHEN KUNING3_1 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED3 = "00000000") THEN
						NEXTSTATE <= H3_RESET;
				else
						nextstate <= KUNING3_1;
				END IF;
		WHEN H3_RESET =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= HIJAU3;
				END IF;
		WHEN HIJAU3 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTUNSIGNED3 = "00000000") THEN
						NEXTSTATE <= K_RESET32;
				else
						nextstate <= HIJAU3;
				END IF;
		WHEN K_RESET32 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING3_2;
				END IF;
		WHEN KUNING3_2 =>
				IF (START = '0') THEN	
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED3 = "00000000") THEN
						NEXTSTATE <= K_RESET41;
				else
						nextstate <= KUNING3_2;
				END IF;
		WHEN K_RESET41 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING4_1;
				END IF;
		WHEN KUNING4_1 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED4 = "00000000") THEN
						NEXTSTATE <= H4_RESET;
				else
						nextstate <= KUNING4_1;
				END IF;
		WHEN H4_RESET =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= HIJAU4;
				END IF;
		WHEN HIJAU4 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTUNSIGNED4 = "00000000") THEN
						NEXTSTATE <= K_RESET42;
				else
						nextstate <= HIJAU4;
				END IF;
		WHEN K_RESET42 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				else
						nextstate <= KUNING4_2;
				END IF;
		WHEN KUNING4_2 =>
				IF (START = '0') THEN
						NEXTSTATE <= MATI;
				ELSIF (COUNTKUNINGUNSIGNED4 = "00000000") THEN
						NEXTSTATE <= ZEBRA1;
				else
						nextstate <= KUNING4_2;
				END IF;
		END CASE;
	END PROCESS;
	
	
	PROCESS (STATE)
	BEGIN
		CASE STATE IS
			WHEN MATI =>
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					LIGHTS_1 <= "000";
					LIGHTS_2 <= "000";
					LIGHTS_3 <= "000";
					LIGHTS_4 <= "000";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
			WHEN ZEBRA1 =>
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <='1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "10";
					CROSS2 <= "10";
					CROSS3 <= "10";
					CROSS4 <= "10";
					address <= "00000";
					COUNT1SIG <= COUNT;
					reset <= '1';

		
			WHEN ZEBRA2 =>
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <='1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "10";
					CROSS2 <= "10";
					CROSS3 <= "10";
					CROSS4 <= "10";
					address <= "00001";
					COUNT2SIG <= COUNT;
					reset <= '0';

			WHEN ZEBRA3 =>
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <='1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "10";
					CROSS2 <= "10";
					CROSS3 <= "10";
					CROSS4 <= "10";
					address <= "00010";
					COUNT3SIG <= COUNT;
			WHEN ZEBRA4 =>
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <='1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "10";
					CROSS2 <= "10";
					CROSS3 <= "10";
					CROSS4 <= "10";
					address <= "00011";
					COUNT4SIG <= COUNT;
			WHEN ZEBRAWAIT =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "10";
					CROSS2 <= "10";
					CROSS3 <= "10";
					CROSS4 <= "10";
					ENABLEZEBRA <= '1';	

			WHEN K_reset11 =>
					LIGHTS_1 <= "010";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '1';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					ENABLEZEBRA <= '0';	
					reset1 <= '1';
			WHEN KUNING1_1 =>
					LIGHTS_1 <= "010";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '1';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					ENABLEZEBRA <= '0';	
					reset1 <= '0';
			WHEN H1_reset =>
					LIGHTS_1 <= "100";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <= '0';
					ENABLE1 <= '1';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					Reset<= '1';
					COUNTKUNING1 <= 5;
			WHEN HIJAU1 =>
					LIGHTS_1 <= "100";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLEZEBRA <= '0';
					ENABLE1 <= '1';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					Reset <='0';
					COUNTKUNING1 <= 5;
			WHEN K_RESET12 =>
					LIGHTS_1 <= "010";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '1';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET1 <= '1';
			WHEN KUNING1_2 =>
					LIGHTS_1 <= "010";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '1';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET1 <= '0';
			WHEN K_RESET21 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "010";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '1';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET2 <= '1';
			WHEN KUNING2_1 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "010";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '1';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET2 <= '0';
			WHEN H2_RESET =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "100";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '1';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET <= '1';
			WHEN HIJAU2 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "100";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '1';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					COUNTKUNING2 <= 5;
					RESET <= '0';
			WHEN K_RESET22 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "010";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '1';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET2 <= '1';
			WHEN KUNING2_2 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "010";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '1';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET2 <= '0';
			WHEN K_RESET31 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "010";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '1';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET3 <= '1';
			WHEN KUNING3_1 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "010";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '1';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET3 <= '0';
			WHEN H3_RESET =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "100";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '1';
					ENABLE4 <= '0';
					COUNTKUNING3 <= 5;
					RESET <= '1';
			WHEN HIJAU3 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "100";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '1';
					ENABLE4 <= '0';
					COUNTKUNING3 <= 5;
					RESET <= '0';
			WHEN K_RESET32 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "010";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '1';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET3 <= '1';
			WHEN KUNING3_2 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "010";
					LIGHTS_4 <= "001";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '1';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET3 <= '0';
			WHEN K_RESET41 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "010";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET4 <= '1';
			WHEN KUNING4_1 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "010";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					RESET4 <= '0';
			WHEN H4_RESET =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "100";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '1';
					COUNTKUNING4 <= 5;
					RESET <= '1';
			WHEN HIJAU4 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "100";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '0';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '1';
					COUNTKUNING4 <= 5;
					RESET <= '0';
			WHEN K_RESET42 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "010";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					countzebra <= 99;
					RESET4 <= '1';
			WHEN KUNING4_2 =>
					LIGHTS_1 <= "001";
					LIGHTS_2 <= "001";
					LIGHTS_3 <= "001";
					LIGHTS_4 <= "010";
					CROSS1 <= "01";
					CROSS2 <= "01";
					CROSS3 <= "01";
					CROSS4 <= "01";
					Enablekuning1 <= '0';
					Enablekuning2 <= '0';
					Enablekuning3 <= '0';
					Enablekuning4 <= '1';
					ENABLE1 <= '0';
					ENABLE2 <= '0';
					ENABLE3 <= '0';
					ENABLE4 <= '0';
					countzebra <= 99;
					RESET4 <='0';
			end case;
		end process;
end architecture;
	
	
	