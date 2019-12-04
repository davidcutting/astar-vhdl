library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
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
end ram;

architecture Behavioral of ram is

type ram_t is array (0 to (2**ADDR_SIZE)-1) of std_logic_vector(WORD_SIZE-1 downto 0);
signal ram_d : ram_t;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                o_data <= (others => '0');
            elsif c_wr = '1' then
                ram_d(to_integer(unsigned(i_addr))) <= i_data;
            end if;
        end if;
    end process;

    o_data <= ram_d(to_integer(unsigned(i_addr)));

end Behavioral;
