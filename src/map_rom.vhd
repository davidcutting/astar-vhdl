library ieee;
use ieee.std_logic_1164.all;

entity map_rom is
    port(
        i_addr : in std_logic_vector(15 downto 0);
        o_data : out std_logic_vector(7 downto 0)
    );
end map_rom;

architecture Behavioral of map_rom is

type map_rom is array (0 to 7, 0 to 7) of std_logic_vector(7 downto 0);
constant map_data : map_rom := (x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"A0", x"A0", x"A0", x"A0", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01",
                                x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01"
                                );

begin

    process(i_addr)
    begin
        o_data <= map_data(
            to_integer(i_addr(15 downto 8)),
            to_integer(i_addr(7 downto 0))
        );  -- read ROM output
    end process;
end Behavioral;
