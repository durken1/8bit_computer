library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_ram is

  port (
    clk  : in std_logic;
    addr : in std_logic_vector(3 downto 0);
    data : in std_logic_vector(7 downto 0);
    we   : in std_logic := '1';
    q    : out std_logic_vector(7 downto 0)
  );

end entity;

architecture rtl of single_port_ram is

  subtype word_t is std_logic_vector(7 downto 0);
  type memory_t is array(15 downto 0) of word_t;

  signal ram      : memory_t;
  signal addr_reg : unsigned(3 downto 0);

begin

  process (clk)
  begin
    if (rising_edge(clk)) then
      if (we = '1') then
        ram(to_integer(unsigned(addr))) <= data;
      end if;

      addr_reg <= unsigned(addr);
    end if;
  end process;

  q <= ram(to_integer(addr_reg));

end architecture;