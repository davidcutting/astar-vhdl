library ieee;
use ieee.std_logic_1164.all;

use work.pair.all;

entity priority_queue is
    generic(
        length  : integer := 16
    );
    port(
        key : in integer; -- cost
        value : in pair_t; -- graph node
        clk, reset, insert, delete : in std_logic; -- clk & ctrl lines
        data : out pair_t; -- lowest priority graph node
        busy, empty, full : out std_logic -- status lines
    );
end priority_queue;

architecture Behavioral of priority_queue is

type node_t is record
    data_present : std_logic;
    key : integer;
    value : pair_t;
end record node_t;

type rows_t is array(0 to length-1) of node_t;
signal top, bot : rows_t; -- two rows to manage temporary space when sorting array

type state_t is (ready, inserting, deleting);
signal state : state_t; -- internal state

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then -- clear rows by setting data_present to 0
                for i in 0 to length-1 loop
                    top(i).data_present <= '0';
                    bot(i).data_present <= '0';
                end loop;
                state <= ready;
            elsif state = ready then
                if insert = '1' then
                    if top(length-1).data_present /= '1' then
                        for i in 1 to length-1 loop
                            top(i) <= top(i-1); -- shift right
                        end loop;
                        top(0) <= ('1', key, value); -- push on top
                        state <= inserting;
                    end if;
                elsif delete = '1' then
                    if bot(0).data_present /= '0' then
                        for i in 0 to length-2 loop
                            bot(i) <= bot(i+1); -- shift left
                        end loop;
                        bot(length-1).data_present <= '0'; -- mark for boom
                        state <= deleting;
                    end if;
                end if;
            elsif state = inserting or state = deleting then
                for i in 0 to length-1 loop -- swap minimum node in to top of queue
                    if top(i).data_present = '1' and (bot(i).data_present = '0' or top(i).key < bot(i).key) then
                        bot(i) <= top(i); -- works because <= take place after process has run?
                        top(i) <= bot(i);
                    end if;
                end loop;
                state <= ready;
            end if;
        end if;
    end process;

    data <= bot(0).value when bot(0).data_present = '1' else (data'range => '0');
    empty <= not bot(0).data_present;
    full <= top(length-1).data_present;
    busy <= '1' when state /= ready else '0';

end Behavioral;
