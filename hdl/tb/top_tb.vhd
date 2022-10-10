library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      port (
      clk : in std_logic;
      rst_n : in std_logic;
      key : in std_logic_vector(1 downto 0);
      switch : in std_logic_vector(8 downto 0);
      led : out std_logic_vector(9 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal key : std_logic_vector(1 downto 0);
  signal switch : std_logic_vector(8 downto 0);
  signal led : std_logic_vector(9 downto 0);

begin

  top_inst : top
    port map (
      clk => clk,
      rst_n => rst_n,
      key => key,
      switch => switch,
      led => led
    );

--   clk_process : process
--   begin
--   clk <= '1';
--   wait for clk_period/2;
--   clk <= '0';
--   wait for clk_period/2;
--   end process clk_process;

end;
