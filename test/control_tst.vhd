library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.pair.all;

entity control_tst is
end control_tst;

architecture Behavioral of control_tst is

component control is
    port (
        clk, reset : in std_logic;
        current_pos : in pair_t;
        goal_pos : in pair_t;
        c_state : out std_logic_vector(2 downto 0);
        c_num_neigh : out std_logic_vector(1 downto 0);
        c_wr_best_neigh : out std_logic;
        c_rst_best_neigh : out std_logic;
        c_wr_curr_pos : out std_logic;
        c_done : out std_logic
    );
end component;

-- inputs
signal clk : std_logic;
signal reset : std_logic;
signal current_pos : pair_t;
signal goal_pos  : pair_t;

-- outputs
signal c_state : std_logic_vector(2 downto 0);
signal c_num_neigh : std_logic_vector(1 downto 0);
signal c_wr_best_neigh : std_logic;
signal c_rst_best_neigh : std_logic;
signal c_wr_curr_pos : std_logic;
signal c_done : std_logic;

-- clock period def
constant clk_freq : time := 100ns;

begin

    uut : control port map (
        clk => clk,
        reset => reset,
        current_pos => current_pos,
        goal_pos => goal_pos,
        c_state => c_state,
        c_num_neigh => c_num_neigh,
        c_wr_best_neigh => c_wr_best_neigh,
        c_rst_best_neigh => c_rst_best_neigh,
        c_wr_curr_pos => c_wr_curr_pos,
        c_done => c_done
    );

    clk_proc : process
    begin
        CLK <= '0';
        wait for clk_freq/2;
        CLK <= '1';
        wait for clk_freq/2;
    end process;

    stim_proc : process
        variable test_pos : pair_t;
        variable test_goal : pair_t;
    begin
        reset <= '1';
        wait for clk_freq;
        test_pos.x := x"3";
        test_pos.y := x"5";
        test_goal.x := x"1";
        test_goal.y := x"6";
        current_pos <= test_pos;
        goal_pos <= test_goal;
        reset <= '0';
        wait;
    end process;

end Behavioral;
