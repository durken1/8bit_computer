library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    key    : in std_logic_vector(1 downto 0);
    switch : in std_logic_vector(8 downto 0);
    led    : out std_logic_vector(9 downto 0)
  );
end entity top;

architecture rtl of top is

begin

  clk_gen_inst : work.clk_gen
  port map(
    clk          => clk,
    clk_man      => key(0),
    clock_switch => switch(0),
    rst_n        => rst_n,
    clk_o        => led(0)
  );

end architecture;