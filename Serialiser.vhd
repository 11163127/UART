library ieee;
use ieee.std_logic_1164.all;

entity Serialiser is
generic
(
    DATA_WIDTH      : integer
);
port
(
    Clk     : in std_logic; -- 50MHz
    Rst     : in std_logic;

    ShiftEn : in std_logic;
    Load    : in std_logic;
    Din     : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    Dout    : out std_logic
);
end entity;

architecture rtl of Serialiser is

signal ShiftRegister    : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    Dout <= ShiftRegister(0);

    SerialiserProcess : process (Rst, Clk)
    begin
        if Rst = '1' then
            ShiftRegister <= (others => '1');
        elsif rising_edge(Clk) then
            if Load = '1' then
                ShiftRegister <= Din;
            elsif ShiftEn = '1' then
                ShiftRegister <= '1' & ShiftRegister(ShiftRegister'left downto 1);
            end if;

        end if;
    end process;
end architecture;