library ieee;
use ieee.std_logic_1164.all;
use work.pair.all;

package node is

    type node_t is record
        data_present : std_logic;
        key : integer;
        value : pair_t;
    end record node_t;

end package node;
