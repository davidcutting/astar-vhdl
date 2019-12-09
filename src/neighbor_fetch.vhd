library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pair.all;

entity neighbor_fetch is
    port (
        current_pos : in pair_t;
        c_num_neigh : in std_logic_vector(1 downto 0);
        neigh_pos   : out pair_t
    );
end neighbor_fetch;

architecture Behavioral of neighbor_fetch is

begin

    u_fetch_neigh : process(c_num_neigh, current_pos)
        variable neigh_pair : pair_t;
    begin
        case c_num_neigh is
            when "00" =>
                neigh_pair.x := current_pos.x;
                neigh_pair.y := current_pos.y + 1;
            when "01" =>
                neigh_pair.x := current_pos.x + 1;
                neigh_pair.y := current_pos.y;
            when "10" =>
                neigh_pair.x := current_pos.x;
                neigh_pair.y := current_pos.y - 1;
            when "11" =>
                neigh_pair.x := current_pos.x - 1;
                neigh_pair.y := current_pos.y;
            when others =>
                neigh_pair := current_pos;
        end case;
        neigh_pos <= neigh_pair;
    end process;

end Behavioral;
