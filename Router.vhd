library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Router is
  port
  (
    wclock, rclock, rst: in std_logic;
    wr1, wr2, wr3, wr4: in std_logic;
    datai1, datai2, datai3, datai4: in std_logic_vector(7 downto 0);
    datao1, datao2, datao3, datao4: out std_logic_vector(7 downto 0)
  );
end entity Router;


architecture Behavioral of Router is
  
  component ib is
    port
    ( 
      Data_in : IN STD_LOGIC_VECTOR (7 downto 0);
      Clock : IN STD_LOGIC;
      Clock_En : IN STD_LOGIC;
      Reset : IN STD_LOGIC;
      Data_out : OUT STD_LOGIC_VECTOR (7 downto 0)
    );
  end component;
  
  component DeMux is
    port
    ( 
      d_in  : IN STD_LOGIC_VECTOR (7 downto 0);
      En : IN STD_LOGIC;
      Sel : IN STD_LOGIC_VECTOR (0 to 1);
      we1, we2, we3, we4: out std_logic;
      d_out1 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out2 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out3 : OUT STD_LOGIC_VECTOR (7 downto 0);
      d_out4 : OUT STD_LOGIC_VECTOR (7 downto 0)
    );
  end component;
  
  component FIFO is
    port
    (
      wclk, rclk, reset: in std_logic;
      rreq, wreq: in std_logic;
      datain: in std_logic_vector(7 downto 0);
      dataout: out std_logic_vector(7 downto 0);
      full, empty: out std_logic
    );
  end component;
  
  component scheduler is
    Port 
    ( 
      clock : in  STD_LOGIC;
      din1 : in  STD_LOGIC_vector (7 downto 0) ;
      din2 : in  STD_LOGIC_vector (7 downto 0) ;
      din3 : in  STD_LOGIC_vector (7 downto 0) ;
      din4 : in  STD_LOGIC_vector (7 downto 0) ;
      rr1, rr2, rr3, rr4: out std_logic;
      dout : out  STD_LOGIC_vector (7 downto 0)
    );
  end component;
  
  -- data outputs of the four input buffers
  signal ib_o1, ib_o2, ib_o3, ib_o4: std_logic_vector (7 downto 0); 
  -- data outputs of the four DeMux
  signal dmux_o11, dmux_o12, dmux_o13, dmux_o14: std_logic_vector (7 downto 0);
  signal dmux_o21, dmux_o22, dmux_o23, dmux_o24: std_logic_vector (7 downto 0);
  signal dmux_o31, dmux_o32, dmux_o33, dmux_o34: std_logic_vector (7 downto 0);
  signal dmux_o41, dmux_o42, dmux_o43, dmux_o44: std_logic_vector (7 downto 0);
  -- write enable outputs of the four DeMux
  signal dmux_we11, dmux_we12, dmux_we13, dmux_we14: std_logic;
  signal dmux_we21, dmux_we22, dmux_we23, dmux_we24: std_logic;
  signal dmux_we31, dmux_we32, dmux_we33, dmux_we34: std_logic;
  signal dmux_we41, dmux_we42, dmux_we43, dmux_we44: std_logic;
  -- data outputs of the 16 FIFOs
  signal FIFO_o11, FIFO_o12, FIFO_o13, FIFO_o14: std_logic_vector (7 downto 0);
  signal FIFO_o21, FIFO_o22, FIFO_o23, FIFO_o24: std_logic_vector (7 downto 0);
  signal FIFO_o31, FIFO_o32, FIFO_o33, FIFO_o34: std_logic_vector (7 downto 0);
  signal FIFO_o41, FIFO_o42, FIFO_o43, FIFO_o44: std_logic_vector (7 downto 0);
  -- full outputs of the 16 FIFOs
  signal FIFO_f11, FIFO_f12, FIFO_f13, FIFO_f14: std_logic;
  signal FIFO_f21, FIFO_f22, FIFO_f23, FIFO_f24: std_logic;
  signal FIFO_f31, FIFO_f32, FIFO_f33, FIFO_f34: std_logic;
  signal FIFO_f41, FIFO_f42, FIFO_f43, FIFO_f44: std_logic;
  -- empty outputs of the 16 FIFOs
  signal FIFO_e11, FIFO_e12, FIFO_e13, FIFO_e14: std_logic;
  signal FIFO_e21, FIFO_e22, FIFO_e23, FIFO_e24: std_logic;
  signal FIFO_e31, FIFO_e32, FIFO_e33, FIFO_e34: std_logic;
  signal FIFO_e41, FIFO_e42, FIFO_e43, FIFO_e44: std_logic;
  -- data outputs of the four schedulers
  signal sch_o1, sch_o2, sch_o3, sch_o4: std_logic_vector (7 downto 0); 
  -- read request outputs of the four schedulers
  signal sch_rr11, sch_rr12, sch_rr13, sch_rr14: std_logic;
  signal sch_rr21, sch_rr22, sch_rr23, sch_rr24: std_logic;
  signal sch_rr31, sch_rr32, sch_rr33, sch_rr34: std_logic;
  signal sch_rr41, sch_rr42, sch_rr43, sch_rr44: std_logic;
  
begin
  
  IB_1: ib port map(datai1, wclock, wr1, rst, ib_o1);
  IB_2: ib port map(datai2, wclock, wr2, rst, ib_o2);
  IB_3: ib port map(datai3, wclock, wr3, rst, ib_o3);
  IB_4: ib port map(datai4, wclock, wr4, rst, ib_o4);
    
  DeMux_1: DeMux port map(ib_o1, wr1, ib_o1(1 downto 0), dmux_we11, dmux_we12, dmux_we13, dmux_we14, dmux_o11, dmux_o12, dmux_o13, dmux_o14);
  DeMux_2: DeMux port map(ib_o2, wr2, ib_o2(1 downto 0), dmux_we21, dmux_we22, dmux_we23, dmux_we24, dmux_o21, dmux_o22, dmux_o23, dmux_o24);
  DeMux_3: DeMux port map(ib_o3, wr3, ib_o3(1 downto 0), dmux_we31, dmux_we32, dmux_we33, dmux_we34, dmux_o31, dmux_o32, dmux_o33, dmux_o34);
  DeMux_4: DeMux port map(ib_o4, wr4, ib_o4(1 downto 0), dmux_we41, dmux_we42, dmux_we43, dmux_we44, dmux_o41, dmux_o42, dmux_o43, dmux_o44);
  
  fifo_11: FIFO port map(wclock, rclock, rst, sch_rr11, dmux_we11, dmux_o11, FIFO_o11, FIFO_f11, FIFO_e11);
  fifo_21: FIFO port map(wclock, rclock, rst, sch_rr21, dmux_we12, dmux_o12, FIFO_o21, FIFO_f21, FIFO_e21);
  fifo_31: FIFO port map(wclock, rclock, rst, sch_rr31, dmux_we13, dmux_o13, FIFO_o31, FIFO_f31, FIFO_e31);
  fifo_41: FIFO port map(wclock, rclock, rst, sch_rr41, dmux_we14, dmux_o14, FIFO_o41, FIFO_f41, FIFO_e41);
  fifo_12: FIFO port map(wclock, rclock, rst, sch_rr12, dmux_we21, dmux_o21, FIFO_o12, FIFO_f12, FIFO_e12);
  fifo_22: FIFO port map(wclock, rclock, rst, sch_rr22, dmux_we22, dmux_o22, FIFO_o22, FIFO_f22, FIFO_e22);
  fifo_32: FIFO port map(wclock, rclock, rst, sch_rr32, dmux_we23, dmux_o23, FIFO_o32, FIFO_f32, FIFO_e32);
  fifo_42: FIFO port map(wclock, rclock, rst, sch_rr42, dmux_we24, dmux_o24, FIFO_o42, FIFO_f42, FIFO_e42);
  fifo_13: FIFO port map(wclock, rclock, rst, sch_rr13, dmux_we31, dmux_o31, FIFO_o13, FIFO_f13, FIFO_e13);
  fifo_23: FIFO port map(wclock, rclock, rst, sch_rr23, dmux_we32, dmux_o32, FIFO_o23, FIFO_f23, FIFO_e23);
  fifo_33: FIFO port map(wclock, rclock, rst, sch_rr33, dmux_we33, dmux_o33, FIFO_o33, FIFO_f33, FIFO_e33);
  fifo_43: FIFO port map(wclock, rclock, rst, sch_rr43, dmux_we34, dmux_o34, FIFO_o43, FIFO_f43, FIFO_e43);
  fifo_14: FIFO port map(wclock, rclock, rst, sch_rr14, dmux_we41, dmux_o41, FIFO_o14, FIFO_f14, FIFO_e14);
  fifo_24: FIFO port map(wclock, rclock, rst, sch_rr24, dmux_we42, dmux_o42, FIFO_o24, FIFO_f24, FIFO_e24);
  fifo_34: FIFO port map(wclock, rclock, rst, sch_rr34, dmux_we43, dmux_o43, FIFO_o34, FIFO_f34, FIFO_e34);
  fifo_44: FIFO port map(wclock, rclock, rst, sch_rr44, dmux_we44, dmux_o44, FIFO_o44, FIFO_f44, FIFO_e44);
    
  scheduler1: scheduler port map(rclock, FIFO_o11, FIFO_o12, FIFO_o13, FIFO_o14, sch_rr11, sch_rr12, sch_rr13, sch_rr14, sch_o1);
  scheduler2: scheduler port map(rclock, FIFO_o21, FIFO_o22, FIFO_o23, FIFO_o24, sch_rr21, sch_rr22, sch_rr23, sch_rr24, sch_o2);
  scheduler3: scheduler port map(rclock, FIFO_o31, FIFO_o32, FIFO_o33, FIFO_o34, sch_rr31, sch_rr32, sch_rr33, sch_rr34, sch_o3);
  scheduler4: scheduler port map(rclock, FIFO_o41, FIFO_o42, FIFO_o43, FIFO_o44, sch_rr41, sch_rr42, sch_rr43, sch_rr44, sch_o4);
    
  datao1 <= sch_o1;
  datao2 <= sch_o2;
  datao3 <= sch_o3;
  datao4 <= sch_o4;
    
end architecture Behavioral;
