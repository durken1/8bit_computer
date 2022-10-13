library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    jmp : in std_logic;
    d   : in std_logic_vector(3 downto 0);
    ce  : in std_logic;
    q   : out std_logic_vector(3 downto 0)
  );
end entity pc;

architecture rtl of pc is

  signal counter : unsigned (3 downto 0);

begin

  process (clk, rst_n)
  begin
    if rst_n = '0' then
      counter <= (others => '0');
    elsif rising_edge(clk) then
      if (jmp = '1') then
        counter <= unsigned(d);
      elsif (ce = '1') then
        counter <= counter + 1;
      end if;
    end if;
  end process;

  q <= std_logic_vector(counter);

end architecture;