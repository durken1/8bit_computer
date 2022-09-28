library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_gen is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    clock_man    : in std_logic;
    clock_switch : in std_logic;
    clk_o        : out std_logic
  );
end entity clk_gen;

architecture rtl of clk_gen is

  signal clock_man_s1 : std_logic;
  signal clock_man_s2 : std_logic;
  signal rst_n_s1     : std_logic;
  signal rst_n_s2     : std_logic;
  signal counter      : unsigned(24 downto 0);

begin

  stabilize : process (clk, rst_n)
  begin
    if rst_n = '0' then
      rst_n_s1     <= '0';
      rst_n_s2     <= '0';
      clock_man_s1 <= '0';
      clock_man_s2 <= '0';
    elsif rising_edge(clk) then
      rst_n_s1     <= rst_n;
      rst_n_s2     <= rst_n_s1;
      clock_man_s1 <= clock_man;
      clock_man_s2 <= clock_man_s1;
    end if;
  end process;

  count : process (clk, rst_n)
  begin
    if rst_n = '0' then
      counter <= (others => '0');
    elsif rising_edge(clk) then
      counter <= to_unsigned(to_integer(counter) + 1, 25);
    end if;
  end process;

  with clock_switch select
    clk_o <= clock_man_s2 when '0',
    counter(24) when others;

end architecture;