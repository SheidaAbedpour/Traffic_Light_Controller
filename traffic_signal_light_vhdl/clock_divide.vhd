library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity clock_divide is
   port(clk_in: in std_logic;
        clk_out: out std_logic);
end clock_divide;
architecture behave of clock_divide is
  signal s_reg,s_next: unsigned(26 downto 0);
  signal oeb_next,oeb_reg: std_logic;
begin
   process(clk_in,s_reg)
   begin
      if(clk_in'event and clk_in = '1') then
         s_reg <= s_next;
	      oeb_reg <= oeb_next;
      end if;
   end process;
   process(s_reg)
   begin
      if(s_reg = 1e6) then
         s_next <= (others => '0');
      else s_next <= s_reg + 1;
      end if;
   end process;
   process(s_next)
   begin
      if(s_next < 5e5) then
         oeb_next <= '1';
      else oeb_next <= '0';
      end if;
   end process;
	clk_out <= oeb_reg;
end behave;