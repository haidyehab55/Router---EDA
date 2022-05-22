library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO is
  port
  (
    wclk, rclk, reset: in std_logic;
    rreq, wreq: in std_logic;
    datain: in std_logic_vector(7 downto 0);
    dataout: out std_logic_vector(7 downto 0);
    full, empty: out std_logic
  );
end entity FIFO;


architecture Behavioral of FIFO is
  
  component FIFO_control is
    generic( add_width:integer:=3 );
    Port 
    ( 
      reset : in  STD_LOGIC;
      rdclk : in  STD_LOGIC;
      wrclk : in  STD_LOGIC;
      r_req : in  STD_LOGIC;
      w_req : in  STD_LOGIC;
      empty : out  STD_LOGIC;
      full : out  STD_LOGIC;
      write_valid : out  STD_LOGIC;
      read_valid : out  STD_LOGIC;
      wr_ptr : out  STD_LOGIC_vector(add_width downto 0);
      rd_ptr : out  STD_LOGIC_vector(add_width downto 0)
		);
  end component;
  
  component DualRam is
    Port 
    ( 
      CLKA  :in  STD_LOGIC;
      CLKB  :in  STD_LOGIC;
      WEA   :in  STD_LOGIC;
      REA   :in  STD_LOGIC;
      ADDRA :in  STD_LOGIC_VECTOR(2 downto 0);
      ADDRB :in  STD_LOGIC_VECTOR(2 downto 0);
      D_IN  :in  STD_LOGIC_VECTOR(7 downto 0);
      D_OUT :out STD_LOGIC_VECTOR(7 downto 0)
    );
  end component;
  
  constant addWidth: integer := 3;
  signal fullSignal, emptySignal: std_logic;
  signal writeValid, readValid: std_logic; 
  signal write_ptr, read_ptr: std_logic_vector(addWidth downto 0);
  signal dout: std_logic_vector (7 downto 0);
  
begin
  
  FIFO_Controller: FIFO_control generic map(addWidth)
    port map
    ( 
      reset, rclk, wclk, rreq, wreq, emptySignal, fullSignal, 
      writeValid, readValid, write_ptr, read_ptr
    );
    
  Ram: DualRam port map
  (
    wclk, rclk, writeValid, readValid, write_ptr(addWidth-1 downto 0), 
    read_ptr(addWidth-1 downto 0), datain, dout
  );
    
  full <= fullSignal;
  empty <= emptySignal;
  dataout <= dout;
  
end architecture Behavioral;
