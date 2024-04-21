library ieee;
use ieee.std_logic_1164.all;

entity Serialiser_tb is
    generic
        (
            DATA_WIDTH      : integer := 8
        );
end entity;

architecture rtl of Serialiser_tb is

    component Serialiser is
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
        end component;

    signal Clk : std_logic := '0';
    signal Rst : std_logic;
    signal ShiftEn : std_logic;
    signal Load : std_logic;
    signal Din  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal Dout : std_logic;
    

begin

    Clk <= not Clk after 10ns;

    UUT : Serialiser
        generic map
        (
            DATA_WIDTH      => DATA_WIDTH
        )
        port map
        (
            Clk     => Clk,
            Rst     => Rst,
        
            ShiftEn => ShiftEn,
            Load    => Load,
            Din     => Din,
            Dout    => Dout
        );

    TestProcess : process
    begin
        Rst <= '1';
        ShiftEn <= '0';
        Load <= '0';
        Din <= (others => '0');
        wait for 100ns;
        Rst <= '0';
        wait for 100ns; 

        wait until rising_edge(Clk);
        Load <= '1';
        Din <= x"AA";
        wait until rising_edge(Clk);
        Load <= '0';
        Din <= (others => '0');

        for i in 0 to 7 loop
            wait for 8.7us;
            wait until rising_edge(Clk);
            ShiftEn <= '1';
            wait until rising_edge(Clk);
            ShiftEn <= '0';
        end loop;

        wait;
    end process;

end architecture;