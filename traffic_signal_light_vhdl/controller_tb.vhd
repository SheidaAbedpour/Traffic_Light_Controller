library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_signal_light_tb is
end traffic_signal_light_tb;

architecture behavioral of traffic_signal_light_tb is
    signal clk_100MHz: std_logic := '0';
    signal rst: std_logic := '0';
    signal main_street: std_logic_vector(2 downto 0);
    signal sub_street: std_logic_vector(2 downto 0);
    signal crosswalk: std_logic_vector(1 downto 0);
    signal timerr: std_logic_vector(3 downto 0);

    constant clk_period: time := 10 ns; 

begin
    dut: entity work.traffic_signal_light
        port map (
            clk_100MHz => clk_100MHz,
            rst => rst,
            main_street => main_street,
            sub_street => sub_street,
            crosswalk => crosswalk,
            timerr => timerr
        );

    -- Clock generation process
    clk_process: process
    begin
        while now < 1000 ns loop  
            clk_100MHz <= '1';
            wait for clk_period / 2;
            clk_100MHz <= '0';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Reset process
    reset_process: process
    begin
        rst <= '1';
        wait for 140 ns; 
        rst <= '0';
		  wait for 20 ns;
		  rst <= '1';
		  wait for 100 ns;
		  rst <= '0';
		  wait for 10 ns;
		  rst <= '1';
        wait;
    end process;


end behavioral;