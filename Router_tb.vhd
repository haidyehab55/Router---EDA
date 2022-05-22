library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Router_tb is
end entity Router_tb;

architecture test of Router_tb is
  
  component Router
    port
    (
      wclock, rclock, rst: in std_logic;
      wr1, wr2, wr3, wr4: in std_logic;
      datai1, datai2, datai3, datai4: in std_logic_vector(7 downto 0);
      datao1, datao2, datao3, datao4: out std_logic_vector(7 downto 0)
    );
  end component;
  
  signal wclock, rclock, rst: std_logic;
  signal wr1, wr2, wr3, wr4: std_logic;
  signal datai1, datai2, datai3, datai4: std_logic_vector(7 downto 0);
  signal datao1, datao2, datao3, datao4: std_logic_vector(7 downto 0);

begin

  dut: Router port map
  (
    wclock, rclock, rst, wr1, wr2, wr3, wr4, datai1, datai2, datai3, datai4, datao1, datao2, datao3, datao4
  );
  
  p1: process is
  begin
    
    wr1 <= '1';
    wr2 <= '1';
    wr3 <= '1';
    wr4 <= '1';
	 datai1 <= "10101000";
	 datai2 <= "10101001";
	 datai3 <= "10101010";
	 datai4 <= "10101011";
    
    rst <= '0';
    wclock <= '1';
    rclock <= '1';    wait for 100ns;
    wclock <= '0';
    rclock <= '0';    wait for 100ns;
    
    wclock <= '1';
    rclock <= '1';    wait for 100ns;
    wclock <= '0';
    rclock <= '0';    wait for 100ns;
    
    wclock <= '1';
    rclock <= '1';    wait for 100ns;
    wclock <= '0';
    rclock <= '0';    wait for 100ns;
    
    wclock <= '1';
    rclock <= '1';    wait for 100ns;
    wclock <= '0';
    rclock <= '0';    wait for 100ns;
    
  end process p1;
  
end architecture test;
