library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FIFO_control is
generic( add_width:integer:=3 );
    Port ( reset : in  STD_LOGIC;
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
end FIFO_control;
architecture Behavioral of FIFO_control is

component GrayCounter is
    Port ( Clock : in  STD_LOGIC; 
           En    : in  STD_LOGIC; --Enable
           Reset : in  STD_LOGIC;
           Count_Out : out  STD_LOGIC_VECTOR(add_width downto 0)); --Gray Code Output
			  
	end component GrayCounter;
	component GraytoBinary is
    Port ( Gray : in  STD_LOGIC_vector(add_width downto 0); --input of the gray code that needs to be converted
           Binary : out  STD_LOGIC_vector(add_width downto 0)); --output of the converted gray code in binary 
end component GraytoBinary;
	
--signals

signal cout_read:STD_LOGIC_vector(add_width downto 0);
signal cout_write:STD_LOGIC_vector(add_width downto 0);
signal empty_s,full_s :std_logic:='0';
signal w_ptr_reg, w_ptr_next: unsigned(add_width+1 downto 0):="00000";
signal r_ptr_reg, r_ptr_next: unsigned(add_width+1 downto 0):="00000";


begin

p:process (rdclk,wrclk ,reset)
   begin
      if (reset='1') then
         w_ptr_reg <= (others=>'0');
         r_ptr_reg <= (others=>'0');
			write_valid<='1';
		   read_valid<='0';
			
		else
       if (rising_edge(wrclk)) then
         w_ptr_reg <= w_ptr_next;
			--validity of write
		   if(full_s='1') then
		   write_valid<='0';
	      else
		   write_valid<='1';
		   end if;
			end if;
		 if(rising_edge(rdclk))then
         r_ptr_reg <= r_ptr_next;
		    --validity of read
		    if(empty_s='1') then
		    read_valid<='0';
		    else
		    read_valid<='1';
		    end if;
			 end if;
      end if;
   end process;
	
	
-- write pointer next-state logic
   w_ptr_next <=
      w_ptr_reg + 1 when w_req='1' and full_s='0' else
      w_ptr_reg;
   full_s <=
      '1' when r_ptr_reg(add_width) /=w_ptr_reg(add_width) and
             r_ptr_reg(add_width-1 downto 0)=w_ptr_reg(add_width-1 downto 0)
          else
      '0';
			
   -- write port output
  -- wr_ptr <= std_logic_vector(w_ptr_reg(add_width downto 0));
  
   full <= full_s;
	
	
   
	
	-- read pointer next-state logic
   r_ptr_next <=
      r_ptr_reg + 1 when r_req='1' and empty_s='0' else
      r_ptr_reg;
   empty_s <= '1' when r_ptr_reg = w_ptr_reg else
              '0';
				  
	-- read port output
  -- rd_ptr <= std_logic_vector(r_ptr_reg(add_width downto 0));
   empty <= empty_s;
	
	--instances
gray_read:GrayCounter port map(Clock=>rdclk,En=>r_req, Reset=>reset, Count_Out=>cout_read);
converter_read:GraytoBinary port map(Gray=>cout_read, Binary=>rd_ptr);
gray_write:GrayCounter port map(Clock=>wrclk,En=>w_req, Reset=>reset, Count_Out=>cout_write);
converter_write:GraytoBinary port map(Gray=>cout_write, Binary=>wr_ptr);
end Behavioral;
