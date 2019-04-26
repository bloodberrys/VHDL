LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


ENTITY MB_MAIN_DIV IS
PORT( HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ADDRESS_INPUT : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		INPUT1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		INPUT2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ENABLER : IN STD_LOGIC;
		CLOCK : IN STD_LOGIC
		);
END ENTITY;


ARCHITECTURE bagi OF MB_MAIN_DIV IS
SIGNAL CLK : STD_LOGIC;
SIGNAL ADDRESS : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL DATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal data1 : std_logic_vector(3 downto 0);
signal data2 : std_logic_vector(3 downto 0);
signal data_reg : std_logic_vector(4 downto 0);
SIGNAL EN :  STD_LOGIC;
SIGNAL Q :  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal gabung : std_logic_vector(3 downto 0);
signal gabung2 : std_logic_vector(7 downto 0);

component MB_DIV
port( datain : in std_logic_vector(3 downto 0);
		datain2 : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		dataout : out std_logic_vector(4 downto 0));
end component;
		
		COMPONENT Seven_Segment
PORT ( NILAI : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 KELUAR : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END COMPONENT; 

BEGIN
CLK <= CLOCK;
EN <= ENABLER;
DATA1 <= INPUT1;
DATA2 <= INPUT2;
ADDRESS <= ADDRESS_INPUT;
GABUNG <= "000" & ADDRESS(4);
GABUNG2 <= "000" & data_reg;
DATA <= gabung2;

Ram32x4_inst : ENTITY WORK.Ram32x4 PORT MAP ( --namanya ram32x4 tapi fungsinya 32x8
		address	 => ADDRESS,
		clock	 => CLK,
		data	 => DATA,
		wren	 => EN,
		q	 => Q
	);

pembagi : MB_DIV port map(data1,data2,clk,data_reg);
SEVSEG0 : Seven_Segment PORT MAP(ADDRESS(3 DOWNTO 0),HEX0);
SEVSEG1 : Seven_Segment PORT MAP(GABUNG,HEX1);
SEVSEG2 : Seven_Segment PORT MAP(DATA(3 DOWNTO 0),HEX2);
SEVSEG3 : Seven_Segment PORT MAP(DATA(7 DOWNTO 4),HEX3); 
SEVSEG4 : Seven_Segment PORT MAP(Q(3 DOWNTO 0),HEX4); 
SEVSEG5 : Seven_Segment PORT MAP(Q(7 DOWNTO 4),HEX5);
SEVSEG6 : Seven_Segment PORT MAP("0000",HEX6);
SEVSeven_Segment : Seven_Segment PORT MAP("0000",HEX7);

END ARCHITECTURE;
