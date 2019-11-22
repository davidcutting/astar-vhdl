entity priority_queue is
    generic(
        wordSize : integer
    );
    port (  clk, reset : in std_logic;
            insert, delete : in std_logic;
            key, value : in std_logic_vector(wordSize-1 downto 0);
            data : out std_logic_vector(wordSize-1 downto 0);
            busy, empty, full : out std_logic
    );
end priority_queue;

architecture Behavioral of priority_queue is

type node is record
    data_present : std_logic;
    key, value : std_logic_vector(wordSize-1 downto 0);
end record node;



begin

    if rising_edge(clk) then
        if reset = '1' then
            for i in 0 to rowSize-1 loop
                data(i) <= '0';
            end loop;
        end if;
    end if;

end Behavioral;
