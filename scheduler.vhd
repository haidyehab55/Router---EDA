library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity scheduler is
    Port ( clock: in  STD_LOGIC;
           din1 : in  STD_LOGIC_vector (7 downto 0) ;
           din2 : in  STD_LOGIC_vector (7 downto 0) ;
           din3 : in  STD_LOGIC_vector (7 downto 0) ;
           din4 : in  STD_LOGIC_vector (7 downto 0) ;
           rr1, rr2, rr3, rr4: out std_logic;
           dout : out  STD_LOGIC_vector (7 downto 0));
end scheduler;

architecture Behavioral of scheduler is

type state_type is (d1,d2,d3,d4);
SIGNAL current_state: state_type := d4;
SIGNAL next_state: state_type;

begin
cs: process (clock)
begin
    if(rising_edge(clock)) then
      current_state <= next_state;
    end if;
end process cs;
	
ns: process(current_state)
begin
	case current_state is
		when d1 =>
			dout <= din1;
			rr1 <= '1';
			rr2 <= '0';
			rr3 <= '0';
			rr4 <= '0';
			next_state <= d2;
		when d2 =>
			dout <= din2;
			rr2 <= '1';
			rr1 <= '0';
			rr3 <= '0';
			rr4 <= '0';
			next_state <= d3;
		when d3 =>
			dout <= din3;
			rr3 <= '1';
			rr2 <= '0';
			rr1 <= '0';
			rr4 <= '0';
			next_state <= d4;
		when d4 =>
			dout <= din4;
			rr4 <= '1';
			rr2 <= '0';
			rr3 <= '0';
			rr1 <= '0';
			next_state <= d1;
	end case;
end process ns;
	
end Behavioral;
