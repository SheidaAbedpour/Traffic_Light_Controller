------------------------------------------------------------------------------------ 
-- Group members: Sheida Abedpour, Matin Azami
-- Project Name:  Traffic Light Controller
-- Description:   VHDL code for a traffic light controller on FPGA is presented.
-- GitHub:        https://github.com/SheidaAbedpour/Traffic_Light_Controller.git
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_signal_light is

	port(clk_100MHz:  in  std_logic;
		  rst: 		   in  std_logic;
		  main_street: out std_logic_vector(2 downto 0);
		  sub_street:  out std_logic_vector(2 downto 0);
		  crosswalk:   out std_logic_vector(1 downto 0)
	);

end traffic_signal_light;


architecture Behavioral of traffic_signal_light is

component clock_divide
   port(clk_in:  in  std_logic;
	     clk_out: out std_logic);
end component;

type states is (GaRbRw, YaRbRw, RaGbRw, RaYbRw, RaRbGw, RaRbRBw, BLINK);
-- GaRbRw:  main street Green,  sub street Red,    crosswalk Red
-- YaRbRw:  main street Yellow, sub street Red,    crosswalk Red
-- RaGbRw:  main street Red,    sub street Green,  crosswalk Red
-- RaYbRw:  main street Red,    sub street Yellow, crosswalk Red
-- RaRbGw:  main street Red,    sub street Red,    crosswalk Green
-- RaRbRBw: main street Red,    sub street Red,    crosswalk Red with Blink
-- BLINK: all red lights are blinking
 
signal cur_state: states:= GaRbRw;
signal timer:   std_logic_vector(3 downto 0):= "0000";
signal clk_1Hz: std_logic;

begin

clock_divider: clock_divide port map(clk_100MHz, clk_1Hz);

process(clk_100MHz, rst) begin

	if(clk_100MHz'event and clk_100MHz = '1') then
	
		if(rst = '0') then 
			cur_state <= BLINK;
			timer <=     "0000";
	
		elsif(rst = '1') then
				
			 case cur_state is
			when GaRbRw =>
				if(timer = "0100") then 
					cur_state <= YaRbRw;
				end if;
				timer <= std_logic_vector(unsigned(timer) + 1);
			when YaRbRw =>
				if(timer = "0110") then 
					cur_state <= RaGbRw;
				end if;
				timer <= std_logic_vector(unsigned(timer) + 1);
			when RaGbRw =>
				if(timer = "1001") then 
					cur_state <= RaYbRw;
				end if;
				timer <= std_logic_vector(unsigned(timer) + 1);
			when RaYbRw =>
				if(timer = "1010") then 
					cur_state <= RaRbGw;
				end if;
				timer <= std_logic_vector(unsigned(timer) + 1);
			when RaRbGw =>
				if(timer = "1100") then 
					cur_state <= RaRbRBw;
				end if;
				timer <= std_logic_vector(unsigned(timer) + 1);
			when RaRbRBw =>
				if(timer = "1110") then
					timer <= "0000";
					cur_state <= GaRbRw;
				else
					cur_state <= RaRbRBw;
					timer <= std_logic_vector(unsigned(timer) + 1);
				end if;
			when BLINK =>
				cur_state <= GaRbRw;
			 end case;
			 
		end if;
	
	end if;

end process;


process(cur_state, clk_100MHz) begin
				
		case cur_state is
	when GaRbRw =>
		main_street <= "100";
		sub_street  <= "001";
		crosswalk   <= "01";
	when YaRbRw =>
		main_street <= "010";
		sub_street  <= "001";
		crosswalk   <= "01";
	when RaGbRw =>
		main_street <= "001";
		sub_street  <= "100";
		crosswalk   <= "01";
	when RaYbRw =>
		main_street <= "001";
		sub_street  <= "010";
		crosswalk   <= "01";
	when RaRbGw =>
		main_street <= "001";
		sub_street  <= "001";
		crosswalk   <= "10";
	when RaRbRBw =>
		main_street  <= "001";
		sub_street   <= "001";
		if(clk_100MHz = '1') then
			crosswalk <= "01";
		else
			crosswalk <= "00";
		end if;
	when BLINK =>
		if(clk_100MHz = '0') then 
			main_street <= "001";
			sub_street  <= "001";
			crosswalk   <= "01";
		else
			main_street <= "000";
			sub_street  <= "000";
			crosswalk   <= "00";
		end if;
		
	end case;
	
end process;

end Behavioral;