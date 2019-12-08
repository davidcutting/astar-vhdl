library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pair.all;

entity cost is
    port (
        neigh_pos, goal_pos : in pair_t;
        neigh_gscore : in integer;
        neigh_fscore : out integer
    );
end cost;

architecture Behavioral of cost is

signal h_score : integer := 0;

begin

    u_h_score : process(neigh_pos, goal_pos)
        variable dx, dy : integer := 0;
    begin
        dx := to_integer( neigh_pos.x ) - to_integer( goal_pos.x );
        dy := to_integer( neigh_pos.y ) - to_integer( goal_pos.y );
        h_score <= abs( dx ) + abs( dy );
    end process;

    u_f_score : process(neigh_gscore, h_score)
    begin
        neigh_fscore <= neigh_gscore + h_score;
    end process;

end Behavioral;
