library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register16 is
    port(
        clk, reset : in std_logic;
        i_data : in std_logic_vector(15 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(15 downto 0)
    );
end register16;

architecture Behavioral of register16 is

begin

    process(clk, reset)
    begin
        if reset = '1' then
            o_data <= (others => '1');
        end if;
        if rising_edge(clk) and c_wr = '1' then
            o_data <= i_data;
        end if;
    end process;

end Behavioral;
