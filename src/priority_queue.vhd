entity priority_queue is
    generic(
            rowSize  : integer
    );
    port (  clk, reset : in std_logic;
            insert, delete : in std_logic;
            key, value : in integer;
            data : out std_logic_vector(wordSize-1 downto 0);
            busy, empty, full : out std_logic
    );
end priority_queue;

architecture Behavioral of priority_queue is

type pair is record
    x : integer;
    y : integer;
end record pair;

type node is record
    data_present : std_logic;
    cost : integer;
    coord : pair;
end record node;

type rows is array(0 to rowSize-1) of node;
signal top, bot : rows;

type state_type is (ready, inserting, deleting);
signal state : state_type;

begin

process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            for i in 0 to rowSize-1 loop
                top(i).data_present <= '0';
                bot(i).data_present <= '0';
            end loop;
            state <= ready;
        elsif state = ready and insert = '1' then
            if top(rowSize-1).data_present /= '1' then
                for i in 1 to rowSize-1 loop
                    top(i) <= top(i-1);
                end loop;
                top(0) <= ('1', key, value);
                state <= inserting;
            end if;
        elsif state = ready and delete = '1' then
            if bot(0).data_present /= '0' then
                for i in 0 to rowSize-2 loop
                    bot(i) <= bot(i+1);
                end loop;
                bot(rowSize-1).data_present <= '0';
                state <= deleting;
            end if

        elsif state = inserting or state = deleting then
            for i in 0 to rowSize-1 loop
                if top(i).data_present = '1' and (bot(i).data_present = '0’ or top(i).cost < bot(i).cost) then
                    bot(i) <= top(i);
                    top(i) <= bot(i);
                end if;
            end loop;
            state <= ready;
        end if;
    end if;
end process;

data <= bot(0).value when bot(0).data_present = '1' else (data’range => '0');
empty <= not bot(0).data_present;
full <= top(rowSize-1).data_present;
busy <= '1' when state /= ready else '0';

end Behavioral;
