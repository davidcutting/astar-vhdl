library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pair is

    type pair_t is record
        x : unsigned(3 downto 0);
        y : unsigned(3 downto 0);
    end record pair_t;

    function to_pair(packed_pair : unsigned(7 downto 0)) return pair_t;
    function pair_to_packed(unpacked_pair : pair_t) return unsigned;

end pair;

package body pair is

    function to_pair(packed_pair : std_logic_vector(7 downto 0)) return pair_t is
        variable temp : pair_t;
    begin
        temp.y := packed_pair(7 downto 4);
        temp.x := packed_pair(3 downto 0);
        return temp;
    end to_pair;

    function pair_to_packed(unpacked_pair : pair_t) return std_logic_vector is
        variable temp : unsigned(7 downto 0);
    begin
        temp(7 downto 4) := unpacked_pair.x;
        temp(3 downto 0)  := unpacked_pair.y;
        return temp;
    end pair_to_packed;

end pair;
