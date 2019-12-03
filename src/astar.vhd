library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.node.all

entity astar is
    port (
        current : in pair_t;
        goal : in pair_t;
        next_pos : out pair_t
    );
end astar;

architecture Behavioral of astar is

component priority_queue is
    generic(
        length  : integer
    );
    port(
        key : in integer; -- cost
        value : in pair_t; -- graph node
        clk, reset, insert, delete : in std_logic; -- clk & ctrl lines
        data : out pair_t; -- lowest priority graph node
        busy, empty, full : out std_logic -- status lines
    );
end component;

component cost is
    port (
        location : in pair_t;
        goal : in pair_t;
        accum_cost : in integer;
        cost   : out integer
    );
end component;

begin



end Behavioral;
