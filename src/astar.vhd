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

-- control signals
signal c_get_neigh  : std_logic; -- control signal to enable neighbor fetching
signal c_num_neigh  : std_logic_vector(1 downto 0); -- control signal for which neighbor to fetch

begin

    -- rom containing cost data for map
    u_cost_map_rom : map_rom port map (
        i_addr => cost_map_i_addr,
        o_data => cost_map_o_data
    );

    -- find neighbors
    u_fetch_neigh : process(clk, c_get_neigh, c_num_neigh)
        variable temp_x : integer;
        variable temp_y : integer;
        variable neigh_pair : pair_t;
    begin
        if rising_edge(clk) and c_get_neigh = '1' then
            case c_num_neigh is
                when "00" =>
                    neigh_pair := current_pos;
                    neigh_pair.y := neigh_pair.y + 1;
                    cost_map_i_addr <= pair_to_packed(neigh_pair);
                when "01" =>
                    neigh_pair := current_pos;
                    neigh_pair.x := neigh_pair.x + 1;
                    cost_map_i_addr <= pair_to_packed(neigh_pair);
                when "10" =>
                    neigh_pair := current_pos;
                    neigh_pair.y := neigh_pair.y - 1;
                    cost_map_i_addr <= pair_to_packed(neigh_pair);
                when "11" =>
                    neigh_pair := current_pos;
                    neigh_pair.x := neigh_pair.x - 1;
                    cost_map_i_addr <= pair_to_packed(neigh_pair);
                end case;
            end if;
    end process;

    -- calculate gscore
    u_each_neigh : for i in 0 to 3 generate
        process(neigh(i))
            variable neigh_gscore : integer;
            variable cost : integer;
            variable x_c : integer := to_integer(current.x);
            variable y_c : integer := to_integer(current.y);
            variable x_n : integer := to_integer(neigh(i).x);
            variable y_n : integer := to_integer(neigh(i).y);
        begin
            neigh_gscore := cost_so_far(x_c, y_c) + 1;
            if neigh_gscore < cost_so_far(x_n, y_n) then
                came_from(x_n, y_n) <= current;
                cost_so_far(x_n, y_n) <= neigh_gscore;
                cost := cost_so_far(x_n, y_n) + to_integer(abs( current.x - goal.x ) + abs( current.y - goal.y ));
            end if;
        end process;
    end generate u_each_neigh;

end Behavioral;
