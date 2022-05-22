library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY DeMux IS
port( d_in  : IN STD_LOGIC_VECTOR (7 downto 0);
      En : IN STD_LOGIC;
      Sel : IN STD_LOGIC_VECTOR (1 downto 0);
      we1, we2, we3, we4: out std_logic;
      d_out1 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out2 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out3 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out4 : OUT STD_LOGIC_VECTOR (7 downto 0));
END ENTITY DeMux;

ARCHITECTURE Behav of DeMux IS

begin
p1: process (En, Sel) IS

begin
   
we1 <= '0';
we2 <= '0';
we3 <= '0';
we4 <= '0';   
   
If En='1' then
        
case Sel IS     -- In case condition we should cover all possible conditions it's necessary
when "00" => 
  d_out1 <= d_in ; 
  we1 <= '1'; 
  d_out2 <="00000000"; 
  d_out3 <= "00000000"; 
  d_out4 <="00000000";-- I make the rest equal 0 to aviod having any values before
when "01" => 
  d_out2 <= d_in; 
  we2 <= '1';
  d_out1 <="00000000"; 
  d_out3 <= "00000010"; 
  d_out4 <= "00000011";
when "10" => 
  d_out3 <= d_in; 
  we3 <= '1';
  d_out1 <="00000000"; 
  d_out2 <="00000001";  
  d_out4 <="00000011";
when "11" => 
  d_out4 <= d_in; 
  we4 <= '1';
  d_out1 <="00000000"; 
  d_out2 <="00000001"; 
  d_out3 <="00000010";
when others => 
  d_out1 <="00000000"; 
  d_out2 <="00000001"; 
  d_out3 <="00000010"; 
  d_out4 <="00000011";

end case;
end if;

end process p1;
end ARCHITECTURE Behav;

