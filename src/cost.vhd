library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pair.all;

entity cost is
    port (
        location : in pair_t;
        goal : in pair_t;
        accum_cost : in integer;
        cost   : out integer
    );
end cost;

architecture Behavioral of cost is

begin

    cost <= accum_cost + to_integer(abs( location.x - goal.x ) + abs( location.y - goal.y ));

end Behavioral;
