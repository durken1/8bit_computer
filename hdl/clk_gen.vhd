library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_gen is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;

    halt         : in std_logic;
    clock_man    : in std_logic;
    clock_switch : in std_logic_vector(1 downto 0);
    clock_o      : out std_logic
  );
end entity clk_gen;

architecture rtl of clk_gen is

  signal clock_man_s1   : std_logic;
  signal clock_man_s2   : std_logic;
  signal clock_man_s3   : std_logic;
  signal clock_man_last : std_logic;
  signal rst_n_s1       : std_logic;
  signal rst_n_s2       : std_logic;
  signal counter        : unsigned(24 downto 0);
  signal clock_toggle   : std_logic;

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
    if rst_n_s2 = '0' then
      counter        <= (others => '0');
      clock_man_last <= '1';
    elsif rising_edge(clk) then
      if (halt = '0') then

        if (clock_man_s2 = '0' and clock_man_last = '1') then
          clock_toggle <= not clock_toggle;
          clock_man_s3 <= clock_man_s2;
        end if;

        case clock_switch is
          when "00" =>
            clock_o <= clock_man_s2;
          when "01" =>
            clock_o <= counter(24);
          when others =>
            clock_o <= clock_toggle;
        end case;

        counter        <= counter + 1;
        clock_man_last <= clock_man_s2;
      end if;
    end if;
  end process;

end architecture;