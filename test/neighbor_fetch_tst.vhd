library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.pair.all;

entity neighbor_fetch_tst is
end neighbor_fetch_tst;

architecture Behavioral of neighbor_fetch_tst is

component neighbor_fetch is
    port (
        current_pos : in pair_t;
        c_num_neigh : in std_logic_vector(1 downto 0);
        neigh_pos   : out pair_t
    );
end component;

-- inputs
signal current_pos : pair_t;
signal c_num_neigh : std_logic_vector(1 downto 0);

-- outputs
signal neigh_pos : pair_t;

begin

    uut : neighbor_fetch port map (
        current_pos => current_pos,
        c_num_neigh => c_num_neigh,
        neigh_pos => neigh_pos
    );

    stim_proc : process
        variable test_pair : pair_t;
    begin
        test_pair.x := x"5";
        test_pair.y := x"2";
        c_num_neigh <= "01";
        current_pos <= test_pair;
        wait;
    end process;

end Behavioral;
