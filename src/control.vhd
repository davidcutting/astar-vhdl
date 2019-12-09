library ieee;
use ieee.std_logic_1164.all;
use work.pair.all;

entity control is
    port (
        clk, reset : in std_logic;
        current_pos : in pair_t;
        goal_pos : in pair_t;
        c_state : out std_logic_vector(2 downto 0);
        c_num_neigh : out std_logic_vector(1 downto 0);
        c_wr_best_neigh : out std_logic;
        c_rst_best_neigh : out std_logic;
        c_wr_curr_pos : out std_logic;
        c_done : out std_logic
    );
end control;

architecture Behavioral of control is

type state_t is (init, fetch_n1, fetch_n2, fetch_n3, fetch_n4, visit, done);
signal state : state_t;

begin

    u_state_transition : process(clk, reset)
    begin
        if reset = '1' then
            state <= init;
        elsif rising_edge(clk) then
            case state is
                when init => state <= fetch_n1;
                when fetch_n1 => state <= fetch_n2;
                when fetch_n2 => state <= fetch_n3;
                when fetch_n3 => state <= fetch_n4;
                when fetch_n4 => state <= visit;
                when visit =>
                    if current_pos = goal_pos then
                        state <= done;
                    else
                        state <= init;
                    end if;
                when done => state <= done;
            end case;
        end if;
    end process;

    u_control : process(state)
    begin
        case state is
            when init =>
                c_state <= "000";
                c_num_neigh <= "00";
                c_wr_best_neigh <= '0';
                c_rst_best_neigh <= '1';
                c_wr_curr_pos <= '0';
                c_done <= '0';
            when fetch_n1 =>
                c_state <= "001";
                c_num_neigh <= "00";
                c_wr_best_neigh <= '1';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '0';
                c_done <= '0';
            when fetch_n2 =>
                c_state <= "010";
                c_num_neigh <= "01";
                c_wr_best_neigh <= '1';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '0';
                c_done <= '0';
            when fetch_n3 =>
                c_state <= "011";
                c_num_neigh <= "10";
                c_wr_best_neigh <= '1';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '0';
                c_done <= '0';
            when fetch_n4 =>
                c_state <= "100";
                c_num_neigh <= "11";
                c_wr_best_neigh <= '1';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '0';
                c_done <= '0';
            when visit =>
                c_state <= "101";
                c_num_neigh <= "11";
                c_wr_best_neigh <= '0';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '1';
                c_done <= '0';
            when done =>
                c_state <= "110";
                c_num_neigh <= "00";
                c_wr_best_neigh <= '0';
                c_rst_best_neigh <= '0';
                c_wr_curr_pos <= '0';
                c_done <= '1';
        end case;
    end process;

end Behavioral;
