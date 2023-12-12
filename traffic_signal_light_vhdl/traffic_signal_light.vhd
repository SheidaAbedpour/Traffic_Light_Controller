------------------------------------------------------------------------------------ 
-- Group members: Sheida Abedpour
-- 					Matin Azami

-- Project Name:  Traffic Light Controller
-- Description:   VHDL code for a traffic light controller on FPGA is presented.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_signal_light is

	port(clk_100MHz: in std_logic;
		  rst: in std_logic;
		  leds: out std_logic_vector(7 downto 0)
	);

end traffic_signal_light;


architecture Behavioral of traffic_signal_light is

component clock_divide
   port(clk_in: in std_logic;
	     clk_out: out std_logic);
end component;

type states is (GaRbRw, YaRbRw, RaGbRw, RaYbRw, RaRbGw, RaRbRw);
signal cur_state, nxt_state: states;
signal count: std_logic_vector(4 downto 0):= "00000";
signal trs_s1, trs_s2, trs_s3, trs_s4, trs_s5, trs_s6: std_logic:= '0';
signal clk_1Hz: std_logic;

begin

clock_divider: clock_divide port map(clk_100MHz, clk_1Hz);

process(clk_1Hz) begin

	 case cur_state is
	when GaRbRw =>
		if(trs_s1 = '1') then
			nxt_state <= YaRbRw;
		end if;
	when YaRbRw =>
		if(trs_s2 = '1') then
			nxt_state <= RaGbRw;
		end if;
	when RaGbRw =>
		if(trs_s3 = '1') then
			nxt_state <= RaYbRw;
		end if;
	when RaYbRw =>
		if(trs_s4 = '1') then
			nxt_state <= RaRbGw;
		end if;
	when RaRbGw =>
		if(trs_s5 = '1') then
			nxt_state <= RaRbRw;
		end if;
	when RaRbRw =>
		if(trs_s6 = '1') then
			nxt_state <= GaRbRw;
		end if;
	 end case;

end process;


end Behavioral;

