library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pair.all;

entity astar is
    port (
        clk, reset : in std_logic;
        start : in pair_t;
        goal : in pair_t;
        next_pos : out pair_t;
        state_flag : out std_logic_vector(2 downto 0);
        done_flag : out std_logic
    );
end astar;

architecture Behavioral of astar is

-- neighbor fetching
component neighbor_fetch is
    port (
        current_pos : in pair_t;
        c_num_neigh : in std_logic_vector(1 downto 0);
        neigh_pos   : out pair_t
    );
end component;

-- cost map
component map_rom is
    port(
        i_addr : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector(7 downto 0)
    );
end component;

-- cost unit
component cost is
    port(
        neigh_pos, goal_pos : in pair_t;
        neigh_gscore : in integer;
        neigh_fscore : out integer
    );
end component;

-- best neighbor register
component register16 is
    port(
        clk, reset : in std_logic;
        i_data : in std_logic_vector(15 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(15 downto 0)
    );
end component;

-- current_pos register
component register8 is
    port(
        clk, reset : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(7 downto 0)
    );
end component;

-- data busses
signal current_pos : pair_t;
signal current_pos_slv : std_logic_vector(7 downto 0);
signal neigh_pos : pair_t; -- neighbor from neighbor fetch
signal best_neigh_slv : std_logic_vector(15 downto 0); -- best neigh from nbest reg
signal neigh_gscore_slv : std_logic_vector(7 downto 0); -- gscore from map to cost unit
signal neigh_fscore : integer; -- calculated neighbor fscore

-- control signals
signal c_num_neigh  : std_logic_vector(1 downto 0); -- control signal for which neighbor to fetch
signal c_wr_best_neigh : std_logic; -- to write to the best neigh register
signal c_rst_best_neigh : std_logic;
signal c_wr_curr_pos : std_logic; -- to write to current position register

signal test : std_logic_vector(15 downto 0);

begin

    -- find neighbors
    u_fetch_neigh : neighbor_fetch port map (
        current_pos => current_pos,
        c_num_neigh => c_num_neigh,
        neigh_pos => neigh_pos
    );

    -- rom containing cost data for map
    u_cost_map_rom : map_rom port map (
        i_addr => pair_to_packed(neigh_pos),
        o_data => neigh_gscore_slv
    );

    -- cost unit to calculate neighbor cost
    u_cost : cost port map (
        neigh_pos => neigh_pos,
        goal_pos => goal,
        neigh_gscore => to_integer(unsigned(neigh_gscore_slv)),
        neigh_fscore => neigh_fscore
    );

    -- register containing the best neighbor
    c_wr_best_neigh <= '1' when neigh_fscore < to_integer(unsigned(best_neigh(7 downto 0))) else '0';
    test <= pair_to_packed(neigh_pos) & std_logic_vector(to_unsigned(neigh_fscore, 8));
    u_best_neigh_reg : register16 port map (
        clk => clk,
        reset => c_rst_best_neigh,
        i_data => test,
        c_wr => c_wr_best_neigh,
        o_data => best_neigh_slv
    );

    u_current_pos_reg : register8 port map (
        clk => clk,
        reset => reset,
        i_data => best_neigh_slv(15 downto 8),
        c_wr => c_wr_curr_pos,
        o_data => current_pos_slv
    );
    current_pos <= to_pair(current_pos_slv);
    next_pos <= current_pos;

    u_control_unit : control port map (
        clk => clk,
        reset => reset,
        current_pos => current_pos,
        goal_pos => goal,
        c_state => state_flag,
        c_num_neigh => c_num_neigh,
        c_wr_best_neigh => c_wr_best_neigh,
        c_rst_best_neigh => c_rst_best_neigh,
        c_wr_curr_pos => c_wr_curr_pos,
        c_done => done_flag
    );

end Behavioral;
