------------------------------------------------------------------------------------ 
-- Group members: Sheida Abedpour, Matin Azami
-- Project Name:  Traffic Light Controller
-- Description:   VHDL code for a traffic light controller on FPGA is presented.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_signal_light is

	port(clk_100MHz: in std_logic;
		  rst: in std_logic;
		  main_street: out std_logic_vector(2 downto 0);
		  sub_street: out std_logic_vector(2 downto 0);
		  crosswalk: out std_logic;
		  timerr: out std_logic_vector(3 downto 0)
	);

end traffic_signal_light;


architecture Behavioral of traffic_signal_light is

--component clock_divide
--   port(clk_in: in std_logic;
--	     clk_out: out std_logic);
--end component;

type states is (GaRbRw, YaRbRw, RaGbRw, RaYbRw, RaRbGw, RaRbRw, BLINK);
signal cur_state: states:= GaRbRw;
signal timer: std_logic_vector(3 downto 0):= "0000";
--signal clk_1Hz: std_logic;
signal blink_signal: std_logic:= '0';

begin

--clock_divider: clock_divide port map(clk_100MHz, clk_1Hz);

process(clk_100MHz, rst) begin

	if(clk_100MHz'event and clk_100Mhz = '1') then
		timer <= std_logic_vector(unsigned(timer) + 1);			
		if(rst = '0') then
			cur_state <= BLINK;
			blink_signal <= not blink_signal;
			timer <= "0000";
		end if;
		
		case cur_state is
	when GaRbRw =>
		if(timer = "0100") then
			cur_state <= YaRbRw;
		end if;
	when YaRbRw =>
		if(timer = "0110") then
			cur_state <= RaGbRw;
		end if;
	when RaGbRw =>
		if(timer = "1001") then
			cur_state <= RaYbRw;
		end if;
	when RaYbRw =>
		if(timer = "1010") then
			cur_state <= RaRbGw;
		end if;
	when RaRbGw =>
		if(timer = "1100") then
			cur_state <= RaRbRw;
		end if;
	when RaRbRw =>
		if(timer = "1110") then
			cur_state <= GaRbRw;
			timer <= "0000";
		end if;
	when BLINK =>
		if(rst = '1') then
			cur_state <= GaRbRw;
		end if;
		
	end case;
	
	end if;

end process;


process(cur_state, blink_signal) begin
				
		case cur_state is
	when GaRbRw =>
		main_street <= "100";
		sub_street <= "001";
		crosswalk <= '0';
	when YaRbRw =>
		main_street <= "010";
		sub_street <= "001";
		crosswalk <= '0';
	when RaGbRw =>
		main_street <= "001";
		sub_street <= "100";
		crosswalk <= '0';
	when RaYbRw =>
		main_street <= "001";
		sub_street <= "010";
		crosswalk <= '0';
	when RaRbGw =>
		main_street <= "001";
		sub_street <= "001";
		crosswalk <= '1';
	when RaRbRw =>
		main_street <= "001";
		sub_street <= "001";
		crosswalk <= '0';
	when BLINK =>
		if(blink_signal = '1') then
			main_street <= "001";
			sub_street <= "001";
			crosswalk <= '1';
		else
			main_street <= "000";
			sub_street <= "000";
			crosswalk <= '0';
		end if;
	
	end case;
	
end process;

timerr <= timer;

end Behavioral;