library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package node is

    type pair_t is record
        x : signed;
        y : signed;
    end record pair_t;

    type node_t is record
        data_present : std_logic;
        key : integer;
        value : pair_t;
    end record node_t;

end package node;
