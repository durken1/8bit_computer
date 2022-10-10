library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    ld_n : in std_logic;
    d    : in std_logic_vector(7 downto 0);
    q    : out std_logic_vector(7 downto 0)
  );
end entity reg;

architecture rtl of reg is

  --------------------------------------
  -- SIGNALS
  --------------------------------------

  signal reg : std_logic_vector(7 downto 0);

begin

  --------------------------------------
  -- PROCESS
  --------------------------------------

  process (clk, rst_n)
  begin
    if rst_n = '0' then
      reg <= (others => '0');
    elsif rising_edge(clk) then
      if (ld_n = '0') then
        reg <= d;
      end if;
    end if;
  end process;

  q <= reg;

end architecture;