library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register8 is
    port(
        clk, reset : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(7 downto 0)
    );
end register8;

architecture Behavioral of register8 is

begin

    process(clk, reset, c_wr)
    begin
        if reset = '1' then
            o_data <= (others => '0');
        end if;
        if rising_edge(clk) and c_wr = '1' then
            o_data <= i_data;
        end if;
    end process;

end Behavioral;
