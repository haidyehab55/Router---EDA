library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




entity GraytoBinary is
    Port ( Gray : in  STD_LOGIC_vector(3 downto 0); --input of the gray code that needs to be converted
           Binary : out  STD_LOGIC_vector(3 downto 0)); --output of the converted gray code in binary 
end GraytoBinary;

architecture Behavioral of GraytoBinary is

begin

process(Gray) is
begin
--The most significant bit stays as it is.
Binary(3) <= Gray(3);

--Each coming binary bit is the result of XOR-ing the most significant gray bits with its corresponding gray bit  
Binary(2) <= Gray(3) xor Gray(2);

Binary(1) <= Gray(3) xor Gray(2) xor Gray(1);

Binary(0) <= Gray(3) xor Gray(2) xor Gray(1) xor Gray(0);

end process;

end Behavioral;


