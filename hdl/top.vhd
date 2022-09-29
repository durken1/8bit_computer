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

  --------------------------------------
  -- SIGNALS
  --------------------------------------

  signal rst_n_s1  : std_logic;
  signal rst_n_s2  : std_logic;
  signal switch_s1 : std_logic_vector(8 downto 0);
  signal switch_s2 : std_logic_vector(8 downto 0);
  signal key_s1    : std_logic_vector (1 downto 0);
  signal key_s2    : std_logic_vector (1 downto 0);

  signal q_regA : std_logic_vector(7 downto 0);
  signal q_regB : std_logic_vector(7 downto 0);
  signal q_regI : std_logic_vector(7 downto 0);

  --------------------------------------
  -- COMPONENTS
  --------------------------------------

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

  component reg
    port (
      clk   : in std_logic;
      rst_n : in std_logic;
      ld_n  : in std_logic;
      d     : in std_logic_vector(7 downto 0);
      q     : out std_logic_vector(7 downto 0)
    );
  end component;

begin

  --------------------------------------
  -- INSTANTIATIONS
  --------------------------------------

  clk_gen_inst : clk_gen
  port map(
    clk          => clk,
    clock_man    => key_s2(0),
    halt         => switch_s2(2),
    clock_switch => switch_s2(1 downto 0),
    rst_n        => rst_n_s2,
    clock_o      => led(0)
  );

  regA_inst : reg
  port map(
    clk   => clk,
    rst_n => rst_n,
    ld_n  => '0',
    d     => x"00",
    q     => q_regA
  );

  regB_inst : reg
  port map(
    clk   => clk,
    rst_n => rst_n,
    ld_n  => '0',
    d     => x"00",
    q     => q_regB
  );

  regI_inst : reg
  port map(
    clk   => clk,
    rst_n => rst_n,
    ld_n  => '0',
    d     => x"00",
    q     => q_regI
  );

  --------------------------------------
  -- PROCESS
  --------------------------------------

  stabilize : process (clk, rst_n)
  begin
    if rst_n = '0' then
      rst_n_s1  <= '0';
      rst_n_s2  <= '0';
      key_s1    <= (others => '0');
      key_s2    <= (others => '0');
      switch_s1 <= (others => '0');
      switch_s2 <= (others => '0');

    elsif rising_edge(clk) then
      rst_n_s1  <= rst_n;
      rst_n_s2  <= rst_n_s1;
      key_s1    <= key;
      key_s2    <= key_s1;
      switch_s1 <= switch;
      switch_s2 <= switch_s1;
    end if;
  end process;

end architecture;