library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.pair.all;

entity register16_tst is
end register16_tst;

architecture Behavioral of register16_tst is

component register16 is
    port(
        clk, reset : in std_logic;
        i_data : in std_logic_vector(15 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(15 downto 0)
    );
end component;

-- inputs
signal clk : std_logic;
signal reset : std_logic;
signal i_data : std_logic_vector(15 downto 0);
signal c_wr : std_logic;

-- outputs
signal o_data : std_logic_vector(15 downto 0);

-- clock period def
constant clk_freq : time := 10ns;

signal coord : pair_t;
signal cost : integer range 0 to 255;

begin

    uut : register16 port map (
        clk => clk,
        reset => reset,
        i_data => i_data,
        c_wr => c_wr,
        o_data => o_data
    );

    clk_proc : process
    begin
        CLK <= '0';
        wait for clk_freq/2;
        CLK <= '1';
        wait for clk_freq/2;
    end process;


    stim_proc : process
    begin
        reset <= '1';
        cost <= 100;
        coord.x <= x"5";
        coord.y <= x"2";
        wait for clk_freq;
        reset <= '0';
        i_data <= pair_to_packed(coord) & std_logic_vector(to_unsigned(cost, 8));
        wait for clk_freq;
        c_wr <= '1';
        wait for clk_freq;
        c_wr <= '0';
        wait;
    end process;

end Behavioral;
