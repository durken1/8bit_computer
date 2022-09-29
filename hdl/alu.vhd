library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity alu is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    regA : in std_logic_vector(7 downto 0);
    regB : in std_logic_vector(7 downto 0);
    eo   : in std_logic;
    su   : in std_logic;
    q    : out std_logic_vector(7 downto 0)
  );
end entity alu;

architecture rtl of alu is

  --------------------------------------
  -- SIGNALS
  --------------------------------------

  signal regA_s : signed(7 downto 0);
  signal regB_s : signed(7 downto 0);

begin

  --------------------------------------
  -- PROCESS
  --------------------------------------

  process (clk, rst_n)
  begin
    if (rst_n = '0') then
      q      <= (others => '0');
      regA_s <= (others => '0');
      regB_s <= (others => '0');

    elsif rising_edge(clk) then
      regA_s <= signed(regA);
      regB_s <= signed(regB);

    elsif (falling_edge(clk)) then
      if (eo = '1') then
        if (su = '1') then
          q <= std_logic_vector(regA_s - regB_s);
        else
          q <= std_logic_vector(regA_s + regB_s);
        end if;
      end if;
    end if;
  end process;

end architecture;