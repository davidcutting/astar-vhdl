library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.pair.all;

entity astar_tst is
end astar_tst;

architecture Behavioral of astar_tst is

component astar is
    port (
        clk, reset : in std_logic;
        start : in pair_t;
        goal : in pair_t;
        next_pos : out pair_t;
        state_flag : out std_logic_vector(2 downto 0);
        done_flag : out std_logic
    );
end component;

-- inputs
signal clk : std_logic;
signal reset : std_logic;
signal start : pair_t;
signal goal  : pair_t;

--outputs
signal next_pos : pair_t;
signal state_flag : std_logic_vector(2 downto 0);
signal done_flag : std_logic;

-- clock period def
constant clk_freq : time := 100ns;

begin

    uut : astar port map (
        clk => clk,
        reset => reset,
        start => start,
        goal => goal,
        next_pos => next_pos,
        state_flag => state_flag,
        done_flag => done_flag
    );

    clk_proc : process
    begin
        CLK <= '0';
        wait for clk_freq/2;
        CLK <= '1';
        wait for clk_freq/2;
    end process;

    stim_proc : process
        variable test_start : pair_t;
        variable test_goal : pair_t;
    begin
        reset <= '1';
        wait for clk_freq;
        test_start.x := x"3";
        test_start.y := x"5";
        test_goal.x := x"1";
        test_goal.y := x"6";
        start <= test_start;
        goal <= test_goal;
        reset <= '0';
        wait;
    end process;

end Behavioral;
