library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_search_TB is
end pattern_search_TB;

architecture Behavioral of pattern_search_TB is
 -- 1 GHz = 2 nanoseconds period
 constant c_CLOCK_PERIOD : time := 2 ns;

 component single_cycle_core is
 PORT(
 reset: in std_logic;
 mode: in std_logic;
 IO_buffer: in std_logic_vector(31 downto 0);
 clk: in std_logic;
 ready: out std_logic;
 count: out std_logic_vector(15 downto 0);
 test_probe : out std_logic_vector(15 downto 0)
 );
 end component;
 --Inputs
 signal mode : std_logic;
 signal IO_buffer : std_logic_vector(31 downto 0);
 signal clk : std_logic := '0';
 signal reset : std_logic := '1';
 --Outputs
 signal ready : std_logic;
 signal count : std_logic_vector(15 downto 0);
 signal test_probe : std_logic_vector(15 downto 0);

begin
 -- Instantiate the Unit Under Test (UUT)
    UUT : single_cycle_core
        port map( reset    => reset,
               mode     => mode,
               IO_buffer=> IO_buffer,
               clk      => clk,
               ready    => ready,
               count    => count,
               test_probe => test_probe);

 -- Clodk process defintions
 --
    p_CLK_GEN : process is
        begin
          wait for c_CLOCK_PERIOD/2;
          clk <= not clk;
        end process p_CLK_GEN; 
         
        process                               -- main testing
        begin
            reset <= '0';
            mode <= '1';
            wait for c_CLOCK_PERIOD;
            reset <= '1';
            wait for c_CLOCK_PERIOD;
            reset <= '0';
            mode <= '0';
            IO_Buffer <= X"00000000";
            -- wait for 100000ns;
            -- wait until ready = '1';
            wait for 5000*c_CLOCK_PERIOD;
        end process;

end Behavioral;
