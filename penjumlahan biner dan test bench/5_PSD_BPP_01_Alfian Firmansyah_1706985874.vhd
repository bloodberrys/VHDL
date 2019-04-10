LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY PENJUMLAHANBINER IS
PORT(	
	INPUT1 : IN STD_LOGIC;
	INPUT2 : IN STD_LOGIC;
	clk : in std_logic;
	output: out std_logic
	);
END ENTITY;

ARCHITECTURE JUMLAHIN OF PENJUMLAHANBINER IS
TYPE STATE_TYPE IS (N,C,blank);
signal state,next_state : STATE_TYPE;
BEGIN
PROCESS IS
BEGIN
	WAIT UNTIL CLK='1' AND CLK'EVENT;
	state <= next_state;
END PROCESS;	

process (state,input1,input2)
begin
case state is 
	when N =>
		IF ( input1 ='1' and input2 ='1' ) then
			next_state <= C;
		elsif (input1='1' and input2 ='0')then
			next_state <= N;
		elsif (input1='0' and input2 ='1')then
			next_state <= N;
		elsif (input1='0' and input2 ='0')then
			next_state <= N;
		else
			next_state <= blank;
		end if;
	when C =>
		IF ( input1 ='1' and input2 ='1' ) then
			next_state <= C;
		elsif (input1='1' and input2 ='0')then
			next_state <= C;
		elsif (input1='0' and input2 ='1')then
			next_state <= C;
		elsif (input1='0' and input2 ='0')then
			next_state <= N;
		else
			next_state <= blank;
		end if;
	when blank =>
		next_state <= blank;
end case;
end process;

process (state,input1,input2)
begin
	case state is
		when N=>
			if (input1='0' and input2='0') then output <= '0';
			elsif (input1='1' and input2='1') then output <= '0';
			elsif (input1='0' and input2='1') then output <= '1';
			elsif (input1='1' and input2='0') then output <= '1';
			else output <= '0';
			end if;
		when C => 
			if (input1='0' and input2='0') then output <= '1';
			elsif (input1='1' and input2='1') then output <= '1';
			elsif (input1='0' and input2='1') then output <= '0';
			elsif (input1='1' and input2='0') then output <= '0';
			else output <= '0';
			end if;
		when blank =>
			output <= 'Z';
end case;
end process;
end architecture;
