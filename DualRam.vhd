library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity DualRam is
    Port ( CLKA  :in  STD_LOGIC;
           CLKB  :in  STD_LOGIC;
           WEA   :in  STD_LOGIC;
           REA   :in  STD_LOGIC;
           ADDRA :in  STD_LOGIC_VECTOR(2 downto 0);
           ADDRB :in  STD_LOGIC_VECTOR(2 downto 0);
           D_IN  :in  STD_LOGIC_VECTOR(7 downto 0);
           D_OUT :out STD_LOGIC_VECTOR(7 downto 0));
end DualRam;

architecture Behavioral of DualRam is

type Dual_ram is Array (7 downto 0) of std_logic_vector(7 downto 0) ;
signal word :  Dual_ram;

begin

wrieP: process(CLKA,WEA,ADDRA) 
begin
if (rising_edge(CLKA) and WEA='1') then
word(conv_integer(ADDRA)) <= D_IN ;
End if ;
end process wrieP ;

readP : process(CLKB,REA,ADDRB)
begin
if (rising_edge(CLKB) and REA='1') then
D_OUT <= word(conv_integer(ADDRB));
End if ;
end process readP ;


end Behavioral;

