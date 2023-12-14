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
		  crosswalk: out std_logic
	);

end traffic_signal_light;


architecture Behavioral of traffic_signal_light is

component clock_divide
   port(clk_in: in std_logic;
	     clk_out: out std_logic);
end component;

type states is (GaRbRw, YaRbRw, RaGbRw, RaYbRw, RaRbGw, RaRbRw);
signal cur_state: states;
signal timer: std_logic_vector(3 downto 0):= "0000";
signal clk_1Hz: std_logic;

begin

clock_divider: clock_divide port map(clk_100MHz, clk_1Hz);

process(clk_1Hz) begin

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
	
	 if(timer = "1110") then timer <= "0000"; else
	 timer <= std_logic_vector(unsigned(timer) + 1);
	 end if;
	 
	 end case;

end process;


process(cur_state) begin

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
		
		end case;

end process;


end Behavioral;

