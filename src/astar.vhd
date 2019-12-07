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

-- cost map
component map_rom is
    port(
        i_addr : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector(7 downto 0)
    );
end component;

-- map data busses
signal cost_map_i_addr : std_logic_vector(7 downto 0);
signal cost_map_o_data : std_logic_vector(7 downto 0);

-- current pos register
signal current_pos : pair_t;
-- current neighbor pos register
signal neigh_pos : pair_t;
-- accumulated movement cost register
signal accum_cost : integer;
-- best neighbor fscore
signal best_fscore : integer := 696969;

type state_t is (fetch, expand, close);
signal state : state_t;

signal error : std_logic;

-- control signals
signal c_get_neigh  : std_logic; -- control signal to enable neighbor fetching
signal c_num_neigh  : std_logic_vector(1 downto 0); -- control signal for which neighbor to fetch
signal c_wr_cur_pos : std_logic; -- to write to current position register
signal c_get_next_node : std_logic; -- write the lowest cost node to current pos register

begin

    u_ctrl : process(clk)
        variable num_neigh : integer(0 to 3) := 0;
    begin
        if rising_edge(clk) then
            case state is
                when fetch =>
                    c_get_next_node <= '0';
                    c_get_neigh <= '1';
                    c_num_neigh <= std_logic_vector(unsigned(num_neigh));
                    state <= expand;
                when expand =>
                    c_get_neigh <= '0';
                    if c_num_neigh = 3 then
                        c_num_neigh <= "00";
                        state <= close;
                    else
                        state <= fetch;
                    end if;
                when close =>
                    c_get_next_node <= '1';
                    state <= fetch;
                when others => error <= '1';
            end case;
        end if;
    end process;

    -- rom containing cost data for map
    u_cost_map_rom : map_rom port map (
        i_addr => cost_map_i_addr,
        o_data => cost_map_o_data
    );

    -- find neighbors
    u_fetch_neigh : process(c_get_neigh, c_num_neigh)
        variable neigh_pair : pair_t;
    begin
        if c_get_neigh = '1' then
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
            cost_map_i_addr <= pair_to_packed(neigh_pair);
            neigh_pos <= neigh_pair;
        end if;
    end process;

    -- find best neighbor
    u_next_best_step : process(neigh_pos, cost_map_o_data)
        variable neigh_gscore : integer;
        variable neigh_hscore : integer;
        variable neigh_fscore : integer;
    begin
        neigh_gscore := accum_cost + to_integer(unsigned(cost_map_o_data));
        neigh_hscore := abs( to_integer(current.x) - to_integer(goal.x) )
                        + abs( to_integer(current.y) - to_integer(goal.y) );
        neigh_fscore := neigh_gscore + neigh_hscore;
        if best_fscore > neigh_fscore then
            accum_cost <= neigh_gscore;
            best_fscore <= neigh_fscore;
        end if;
    end process;

    u_move : process(c_get_next_node)
    begin
        if c_get_next_node = '1' then
            current_pos <= neigh_pos;
            best_fscore <= 696969;
        end if;
    end process;

end Behavioral;
