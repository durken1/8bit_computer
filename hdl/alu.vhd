library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
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
  signal q_s    : signed(7 downto 0);

begin

  regA_s <= signed(regA);
  regB_s <= signed(regB);

  q <= std_logic_vector(q_s) when eo = '1';

  --------------------------------------
  -- PROCESS
  --------------------------------------

  process (regA_s, regB_s, eo, su) is
  begin
    if (su = '1') then
      q_s <= regA_s - regB_s;
    else
      q_s <= regA_s + regB_s;
    end if;
  end process;

end architecture rtl;