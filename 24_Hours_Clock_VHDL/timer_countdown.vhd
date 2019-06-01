library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity jam_digital is
generic(frequency : integer);
port(
    clk     : in std_logic;
    reset    : in std_logic; 
    detik : inout integer;	-- ini berguna untuk counter yang detik dalam satuan integer 
    menit : inout integer;	-- ini juga sama, untuk counter aja 
    jam   : inout integer; -- ini juga untuk counter dalam integer
    out_lsb_jam, out_msb_jam, out_lsb_menit, out_msb_menit, out_lsb_detik, out_msb_detik : out std_logic_vector(6 downto 0) 
	--nah yang ini untuk register output yang bakalan dipake untuk seven segment, jadi kita bakal ada 6 seven segment.
	-- 1. LSB detik
	-- 2. MSB detik
	-- 3. LSB menit
	-- 4. MSB menit
	-- 5. LSB jam
	-- 6. MSB jam
	
	-- kira-kira ilustrasi posisi seven segmentnya gini: (ceritanya ini jam digital seven segment)
-- .--------------------------------------------------------------------.	
-- |          |         |           |           |           |           |
-- |  JAM MSB | JAM LSB | MENIT MSB | MENIT LSB | DETIK MSB | DETIK LSB |
-- |	      |         |           |           |           |           |
-- '--------------------------------------------------------------------'
 	);	
end entity;
 
architecture rtl of jam_digital is
 
    signal satu_berdetik : integer;						-- ini buat detikan frekuensi doang
	signal lsb_detik : std_logic_vector( 3 downto 0 );  -- buat signal input detik lsb case yang bakal dicocokin ke vhdnya seven segment 
	signal lsb_menit : std_logic_vector( 3 downto 0);  -- sama, ini bakal di bawa ke portmapnya seven segment 
	signal lsb_jam : std_logic_vector(3 downto 0);  -- dst
	signal msb_detik : std_logic_vector( 3 downto 0 ); -- dst
	signal msb_menit : std_logic_vector( 3 downto 0); -- dst
	signal msb_jam : std_logic_vector(3 downto 0); -- SIGNAL - SIGNAL INILAH YANG BAKALAN JADI SIGNAL INPUT BUAT NGECOCOKIN KE SEVEN SEGMENNYA

COMPONENT Seven_Segment									-- nah disini kita ngeport component seven segment aja sih, dengan isi port yang sama kaya vhd nya
PORT ( 		NILAI : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- ini nilai yang bakalan jadi parameter mau dimasukin signal tadi yang lsb atau msb, detik/menit/jam
		 KELUAR : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));  -- nah ini bakal pake register yang di port entity di atas untuk outputnya
END COMPONENT; 


	
begin

    process(clk) is

	
    begin
        if rising_edge(clk) then
 
            -- kalo reset nilainya '0' maka reset si jam digital, artinya kalo '1' si jam bakalan nyala deh
            if reset = '0' then
                satu_berdetik   <= 0;
                detik <= 0;
                menit <= 0;
                jam   <= 0;
		lsb_detik <= "0000";		-- reset aja semua nilainya 
		lsb_menit <= "0000";
		lsb_jam <= "0000";
		msb_detik <= "0000";
		msb_menit <= "0000";
		msb_jam <= "0000";
            else					-- nah disinilah else kalo resetnya '1', artinya jam nyala
 
                -- hitungan detik frekuensinya aja sih ini
                if satu_berdetik = frequency - 1 then
                    satu_berdetik <= 0;
 
                    -- hitungan menit yaitu 1 menit = 60 detik
                    if detik = 59 then   -- sebenernya ini kalo detikan udah sampe 59 ya reset, tapi liat ke bawah dulu yang bagian detik line (131)
                        detik <= 0;
						lsb_detik <= "0000";
						msb_detik <= "0000";
			
                        -- hitungan jam yaitu 1 jam = 60 menit
                        if menit = 59 then
                            menit <= 0;
							lsb_menit <= "0000";
							msb_menit <= "0000";
                            -- harian yaitu 1 hari = 24 jam
                            if jam = 23 then
                                jam <= 0;
								lsb_jam <= "0000";
								msb_jam <= "0000";
                            else
					
								if jam = 9 or jam = 19 then
									jam <= jam + 1;
									lsb_jam <= "0000";
									msb_jam <= std_logic_vector( unsigned(msb_jam) + 1 );
								elsif (jam > 9 and jam < 20) or (jam > 19) then
									lsb_jam <= std_logic_vector( unsigned(lsb_jam) + 1 );
									jam <= jam + 1;
								else
								   jam <= jam + 1;
								   lsb_jam <= std_logic_vector( unsigned(lsb_jam) + 1 );
								end if;

                            end if;
 
                        else
                            if menit = 9 or menit = 19 or menit = 29 or menit = 39 or menit = 49 then
								menit <= menit + 1;
								lsb_menit <= "0000";
								msb_menit <= std_logic_vector( unsigned(msb_menit) + 1 );
							elsif (menit > 9 and menit < 20) or (menit > 19 and menit < 30) or (menit > 29 and menit < 40) or 
								(menit > 39 and menit < 50) or (menit > 49 and menit < 60)  then
								lsb_menit <= std_logic_vector( unsigned(lsb_menit) + 1 );
								menit <= menit + 1;
							else
								menit <= menit + 1;
								lsb_menit <= std_logic_vector( unsigned(lsb_menit) + 1 );
							end if;
                        end if;
 
                    else
                        if detik = 9 or detik = 19 or detik = 29 or detik = 39 or detik = 49 then		--  nah ketika dia 9 atau 19 atau 29 atau 39 dst
							detik <= detik + 1;									-- ini tetep counter ya
							lsb_detik <= "0000";								-- ketika si lsb udah 9, ya reset si lsb, terus msb yang di increment
							msb_detik <= std_logic_vector( unsigned(msb_detik) + 1 );   --nah ini increment msbnya jadi 1, artinya jam dari 09 ke 10 :)
						elsif (detik > 9 and detik < 20) or (detik > 19 and detik < 30) or (detik > 29 and detik < 40) or 
					      (detik > 39 and detik < 50) or (detik > 49 and detik < 60)  then
							lsb_detik <= std_logic_vector( unsigned(lsb_detik) + 1 );
							detik <= detik + 1;
						else									-- mulainya dari sini, si lsb doang yang jalan abis itu, kalo udah lebih dari 9
						   detik <= detik + 1;					-- ini counternya jalan
						   lsb_detik <= std_logic_vector( unsigned(lsb_detik) + 1 );   -- nih lsb si detik yang jalan terus-terusan sampe nilainya 9, nah kalo udah 9 bakal naek ke if pertama
						end if;
                    end if;
 
                else
                    satu_berdetik <= satu_berdetik + 1;
                end if;
 
            end if;
        end if;
    end process;

DISPLAY_DETIK_LSB : Seven_Segment PORT MAP(lsb_detik,out_lsb_detik);		-- ini buat import map, dan import signal input dan register outputnya
DISPLAY_DETIK_MSB : Seven_Segment PORT MAP(msb_detik,out_msb_detik);
DISPLAY_MENIT_LSB : Seven_Segment PORT MAP(lsb_menit,out_lsb_menit);
DISPLAY_MENIT_MSB : Seven_Segment PORT MAP(msb_menit,out_msb_menit);
DISPLAY_JAM_LSB : Seven_Segment PORT MAP(lsb_jam,out_lsb_jam);
DISPLAY_JAM_MSB : Seven_Segment PORT MAP(msb_jam,out_msb_jam);
 
end architecture;
