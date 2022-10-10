library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.data_types.all;

entity output_sel is
  port (
    clk   : in std_logic;
    rst_n : in std_logic;
    
    sel : in std_logic_vector(2 downto 0);
    q_sel : out output_en
  );
end entity output_sel;

architecture rtl of output_sel is

begin

  process (clk, rst_n)
  begin
    if rst_n = '0' then
      q_sel <= none;
    elsif rising_edge(clk) then
      case sel is
        when "000" =>
          q_sel <= none;
          when "001" =>
          q_sel <= regA_o;
          when "010" =>
          q_sel <= regB_o;
          when "011" =>
          q_sel <= regI_o;
          when "100" =>
          q_sel <= alu_o;
          when "101" =>
          q_sel <= ram_o;
        when others =>
          null;
      end case;
    end if;
  end process;

end architecture;