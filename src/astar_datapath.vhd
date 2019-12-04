library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.node.all

entity astar_datapath is
    port (
        clk, reset : in std_logic
    );
end astar_datapath;

architecture Behavioral of astar_datapath is

component ram is
    generic(
        WORD_SIZE : integer := 8;
        ADDR_SIZE : integer := 16
    );
    port(
        clk, reset : in std_logic;
        i_addr : in std_logic_vector(ADDR_SIZE-1 downto 0);
        i_data : in std_logic_vector(WORD_SIZE-1 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end component;

    signal weights : std_logic_vector(7 downto 0);

begin

    u_weight_mem : ram generic map (
        WORD_SIZE <= 8,
        ADDR_SIZE <= 16
    )
    port map (
        clk => clk,
        reset => reset,

    );

    -- find neighbors

    -- generate cost of each neighbor
    neigh_cost_net : for i in 0 to 7 generate
        u_cost : cost port map (
            location => neigh_node(i),
            goal => goal_pos,
            accum_cost => acc_cost,
            cost => neigh_cost(i)
        );
    end generate neigh_cost_net;

end Behavioral;
