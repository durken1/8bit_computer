library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

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

  -- Meta stabilization
  signal rst_n_s1  : std_logic;
  signal rst_n_s2  : std_logic;
  signal switch_s1 : std_logic_vector(8 downto 0);
  signal switch_s2 : std_logic_vector(8 downto 0);
  signal key_s1    : std_logic_vector (1 downto 0);
  signal key_s2    : std_logic_vector (1 downto 0);

  -- alu control
  signal alu_eo : std_logic;
  signal alu_su : std_logic;

  -- register control
  signal ld_regA : std_logic;
  signal ld_regB : std_logic;
  signal ld_regI : std_logic;

  -- bus control
  signal q_sel  : output_en;
  signal bus0   : std_logic_vector(7 downto 0);
  signal q_regA : std_logic_vector(7 downto 0);
  signal q_regB : std_logic_vector(7 downto 0);
  signal q_regI : std_logic_vector(7 downto 0);
  signal q_alu  : std_logic_vector(7 downto 0);

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

  component alu
    port (
      clk   : in std_logic;
      rst_n : in std_logic;
      regA  : in std_logic_vector(7 downto 0);
      regB  : in std_logic_vector(7 downto 0);
      eo    : in std_logic;
      su    : in std_logic;
      q     : out std_logic_vector(7 downto 0)
    );
  end component;

  component output_sel
    port (
      clk   : in std_logic;
      rst_n : in std_logic;
      sel   : in std_logic_vector(2 downto 0);
      q_sel : out output_en
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
    rst_n => rst_n_s2,
    ld_n  => ld_regA,
    d     => bus0,
    q     => q_regA
  );

  regB_inst : reg
  port map(
    clk   => clk,
    rst_n => rst_n_s2,
    ld_n  => ld_regB,
    d     => bus0,
    q     => q_regB
  );

  regI_inst : reg
  port map(
    clk   => clk,
    rst_n => rst_n_s2,
    ld_n  => ld_regI,
    d     => bus0,
    q     => q_regI
  );

  alu_inst : alu
  port map(
    clk   => clk,
    rst_n => rst_n_s2,
    regA  => q_regA,
    regB  => q_regB,
    eo    => alu_eo,
    su    => alu_su,
    q     => q_alu
  );

  output_sel_inst : output_sel
  port map(
    clk   => clk,
    rst_n => rst_n,
    sel   => switch(8 downto 6),
    q_sel => q_sel
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

  --------------------------------------
  -- BUS
  --------------------------------------

  with q_sel select bus0 <=
    q_regA when regA_o,
    q_regB when regB_o,
    q_regI when regI_o,
    q_alu when alu_o,
    x"00" when others;

  led(9 downto 2) <= bus0;

end architecture;