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

  component clk_gen
    port (
      clk          : in std_logic;
      rst_n        : in std_logic;
      halt         : in std_logic;
      clock_man    : in std_logic;
      clock_switch : in std_logic_vector(1 downto 0);
      clock_o      : out std_logic
    );
  end component;

begin

  clk_gen_inst : clk_gen
  port map(
    clk          => clk,
    clock_man    => key(0),
    halt         => switch(2),
    clock_switch => switch(1 downto 0),
    rst_n        => rst_n,
    clock_o      => led(0)
  );

end architecture;