library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pair.all;

entity astar is
    port (
        clk, reset : in std_logic;
        start : in pair_t;
        goal : in pair_t
    );
end astar;

architecture Behavioral of astar is

-- used for came_from and cost_so_far mem
component ram is
    generic(
        WORD_SIZE : integer := 32;
        ADDR_SIZE : integer := 32
    );
    port(
        clk, reset : in std_logic;
        i_addr : in std_logic_vector(ADDR_SIZE-1 downto 0);
        i_data : in std_logic_vector(WORD_SIZE-1 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end component;

-- u_came_from_mem
signal b_came_from_addr : std_logic_vector(31 downto 0);
signal b_came_from_i_data : std_logic_vector(31 downto 0);
signal b_came_from_o_data : std_logic_vector(31 downto 0);
signal c_came_from_wr   : std_logic;

-- u_cost_so_far_mem
signal b_cost_so_far_addr : std_logic_vector(31 downto 0);
signal b_cost_so_far_i_data : std_logic_vector(31 downto 0);
signal b_cost_so_far_o_data : std_logic_vector(31 downto 0);
signal c_cost_so_far_wr   : std_logic;

-- keeping track of nodes
type pair_array_t is array (0 to 15) of pair_t;
signal came_from : pair_array_t;
signal cost_so_far : pair_array_t;
signal current : pair_t := start;

-- neighbors
type neigh_array_t is array (0 to 3) of pair_t;
signal neigh : neigh_array_t;

-- control signals
signal c_get_neigh;

begin

    -- add ram here for came_from and cost_so_far
    u_came_from_mem : ram port map (
        clk => clk,
        reset => reset,
        i_addr => b_came_from_addr,
        i_data => b_came_from_i_data,
        c_wr => c_came_from_wr,
        o_data => b_came_from_o_data
    );

    u_cost_so_far_mem : ram port map (
        clk => clk,
        reset => reset,
        i_addr => b_cost_so_far_addr,
        i_data => b_cost_so_far_i_data,
        c_wr => c_cost_so_far_wr,
        o_data => b_cost_so_far_o_data
    );

    -- find neighbors
    process(clk, c_get_neigh)
    begin
        if rising_edge(clk) and c_get_neigh = '1' then
            neigh(0) <= (current.x, current.y + 1);
            neigh(1) <= (current.x + 1, current.y);
            neigh(2) <= (current.x, current.y - 1);
            neigh(3) <= (current.x -1, current.y);
        end if;
    end process;

    -- calculate gscore
    u_each_neigh : for i in 0 to 3 generate
        process(neigh(i))
            variable neigh_gscore := integer;
        begin
            --neigh_gscore := cost_so_far[current] + 1;
            cost <= accum_cost + to_integer(abs( current.x - goal.x ) + abs( current.y - goal.y ));
        end process;
    end generate u_each_neigh;

end Behavioral;
