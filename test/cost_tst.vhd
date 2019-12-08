library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.pair.all;

entity cost_tst is
end cost_tst;

architecture Behavioral of cost_tst is

component cost is
    port (
        neigh_pos, goal_pos : in pair_t;
        neigh_gscore : in integer;
        neigh_fscore : out integer
    );
end component;

-- inputs
signal neigh_pos : pair_t;
signal goal_pos  : pair_t;
signal neigh_gscore : integer;

-- outputs
signal neigh_fscore : integer;

begin

    uut : cost port map (
        neigh_pos => neigh_pos,
        goal_pos => goal_pos,
        neigh_gscore => neigh_gscore,
        neigh_fscore => neigh_fscore
    );

    stim_proc : process
        variable test_goal : pair_t;
        variable test_neigh : pair_t;
    begin
        test_neigh.x := x"5";
        test_neigh.y := x"2";
        neigh_pos <= test_neigh;
        
        test_goal.x := x"1";
        test_goal.y := x"6";
        goal_pos <= test_goal;
        neigh_gscore <= 1;
        wait;
    end process;

end Behavioral;
