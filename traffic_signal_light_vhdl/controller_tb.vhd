LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY controller_tb IS
END controller_tb;
 
ARCHITECTURE behavior OF controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT traffic_signal_light
    PORT(
         clk_100MHz : IN  std_logic;
         rst : IN  std_logic;
         main_street : OUT  std_logic_vector(2 downto 0);
         sub_street : OUT  std_logic_vector(2 downto 0);
         crosswalk : OUT  std_logic;
         timerr : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_100MHz : std_logic := '0';
   signal rst : std_logic := '1';

 	--Outputs
   signal main_street : std_logic_vector(2 downto 0);
   signal sub_street : std_logic_vector(2 downto 0);
   signal crosswalk : std_logic;
   signal timerr : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: traffic_signal_light PORT MAP (
          clk_100MHz => clk_100MHz,
          rst => rst,
          main_street => main_street,
          sub_street => sub_street,
          crosswalk => crosswalk,
          timerr => timerr
        );

   -- Clock process definitions
   clk_100MHz_process :process
   begin
		clk_100MHz <= '0';
		wait for clk_100MHz_period/2;
		clk_100MHz <= '1';
		wait for clk_100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_100MHz_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
