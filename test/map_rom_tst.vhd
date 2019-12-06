library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pair.all;

entity map_rom_tst is
end map_rom_tst;

architecture Behavioral of map_rom_tst is

component map_rom is
    port(
        i_addr : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector(7 downto 0)
    );
end component;

-- inputs
signal i_addr : std_logic_vector(7 downto 0);

-- outputs
signal o_data : std_logic_vector(7 downto 0);

-- pair
signal coord : pair_t;

begin

    uut : map_rom port map (
        i_addr => i_addr,
        o_data => o_data
    );

    stim_proc : process
    begin
        coord.x <= x"05";
        coord.y <= x"05";
        i_addr <= std_logic_vector(pair_to_packed(coord));
        wait for 100ns;
    end process;

end Behavioral;
