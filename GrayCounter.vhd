library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;



entity GrayCounter is
    Port ( Clock : in  STD_LOGIC; 
           En    : in  STD_LOGIC; --Enable
           Reset : in  STD_LOGIC;
           Count_Out : out  STD_LOGIC_VECTOR(3 downto 0)); --Gray Code Output
			  
	end GrayCounter;		  
			  
architecture behavioral of GrayCounter is

signal count : std_logic_vector(3 downto 0) := "0000"; --count is a vector initialized to 0000 in order to be incremented
begin
 process(Clock)
 begin
 if (En='1') then 
  if (Reset='1') then
   count <= "0000";
  elsif (rising_edge(Clock)) then
   count <= count + "0001"; --count is incremented in the rising edge
  end if;
  end if;
 end process;
    Count_Out <= count xor ('0' & count(3 downto 1)); --xor count with the 3 least significant bits of count while concatenating the 0 at most significant bit and result is written into Count_Out

end Behavioral;
