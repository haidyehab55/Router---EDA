library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY ib IS
port( Data_in : IN STD_LOGIC_VECTOR (7 downto 0);
      Clock : IN STD_LOGIC;
      Clock_En : IN STD_LOGIC;
      Reset : IN STD_LOGIC;
      Data_out : OUT STD_LOGIC_VECTOR (7 downto 0));
END ENTITY ib;

ARCHITECTURE Behav of ib IS

BEGIN
p1: process IS
begin

if (Reset = '1') then
  Data_out <= "00000000";
  
elsif (Clock_En = '1' and rising_edge (Clock)) then
  Data_out <= Data_in;

end if;

wait on Clock_En,Reset,Clock;
end process p1;
end architecture Behav;
