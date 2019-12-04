library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pair is

    type pair_t is record
        x : signed(15 downto 0);
        y : signed(15 downto 0);
    end record pair_t;

    function to_pair(packed_pair : signed(31 downto 0)) return pair_t;
    function pair_to_packed(unpacked_pair : pair_t) return signed;

end pair;

package body pair is

    function to_pair(packed_pair : signed(31 downto 0)) return pair_t is
        variable temp : pair_t;
    begin
        temp.y := packed_pair(31 downto 16);
        temp.x := packed_pair(15 downto 0);
        return temp;
    end to_pair;

    function pair_to_packed(unpacked_pair : pair_t) return signed is
        variable temp : signed(31 downto 0);
    begin
        temp(31 downto 16) := unpacked_pair.x;
        temp(15 downto 0)  := unpacked_pair.y;
        return temp;
    end pair_to_packed;

end pair;
