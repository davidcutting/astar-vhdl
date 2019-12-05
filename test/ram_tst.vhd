library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pair.all

entity ram_tst is
end ram_tst;

architecture Behavioral of sequence_det_tst is

component ram is
    generic(
        WORD_SIZE : integer := 32;
        ADDR_SIZE : integer := 32
    );
    port(
        clk, reset : in std_logic;
        i_addr : in std_logic_vector(ADDR_SIZE-1 downto 0);
        i_data : in std_logic_vector(WORD_SIZE-1 downto 0);
        c_wr : in std_logic;
        o_data : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end component;

-- inputs
signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
signal i_addr : std_logic_vector(ADDR_SIZE-1 downto 0);
signal i_data : std_logic_vector(WORD_SIZE-1 downto 0);
signal c_wr   : std_logic;

-- outputs
signal o_data : std_logic_vector(WORD_SIZE-1 downto 0);

-- test variables
signal pair1 : pair_t;
signal pair2 : pair_t;

-- clock period def
constant CLK_FREQ : time := 100ns;

begin

    uut : ram port map (
        clk => clk,
        reset => reset,
        i_addr => i_addr,
        i_data => i_data,
        c_wr => c_wr,
        o_data => o_data
    );

    CLK_proc : process
    begin
        CLK <= '0';
        wait for CLK_FREQ/2;
        CLK <= '1';
        wait for CLK_FREQ/2;
    end process;

    stim_proc : process
    begin
        reset <= '1';
        wait for CLK_FREQ;
        reset <= '0';
        wait for CLK_FREQ;
        i_addr <= pair_to_packed(pair1);
        i_data <= "00000101";
        c_wr <= '1';
        wait for CLK_FREQ;
        c_wr <= '0';
        wait for CLK_FREQ;
    end process;

end Behavioral;
