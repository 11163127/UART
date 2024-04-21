library ieee;
use ieee.std_logic_1164.all;

entity UART_tx_tb is
generic
(
    RS232_DATA_BITS : integer := 8;
    SYS_CLK_FREQ    : integer := 50000000;
    BAUD_RATE       : integer := 50000
);
end entity;

architecture rtl of UART_tx_tb is

    component UART_tx is
        generic
        (
            RS232_DATA_BITS : integer;
            SYS_CLK_FREQ    : integer;
            BAUD_RATE       : integer
        );
        port
        (
            Clk         : in std_logic;
            Rst         : in std_logic;
        
            TxStart     : in std_logic;
            TxData      : in std_logic_vector(RS232_DATA_BITS - 1 downto 0);
        
            UART_tx_pin : out std_logic;
            TxReady     : out std_logic
        );
    end component;

    signal Clk         :  std_logic := '0';
    signal Rst         :  std_logic;
    signal TxStart     :  std_logic;
    signal TxData      :  std_logic_vector(RS232_DATA_BITS - 1 downto 0);
    signal UART_tx_pin :  std_logic;
    signal TxReady     :  std_logic;
begin

    Clk <= not Clk after 10ns; -- simulate 50MHz clock

    UART_tx_inst : UART_tx
        generic map
        (
            RS232_DATA_BITS => RS232_DATA_BITS,
            SYS_CLK_FREQ    => SYS_CLK_FREQ,
            BAUD_RATE       => BAUD_RATE
        )
        port map
        (
            Clk         => Clk,
            Rst         => Rst,
        
            TxStart     => TxStart,
            TxData      => TxData,
        
            UART_tx_pin => UART_tx_pin,
            TxReady     => TxReady
        );

    TestProcess : process 
    begin
        Rst <= '1';
        TxStart <= '0';
        TxData <= (others => '0');
        wait for 100ns;
        Rst <= '0';
        wait for 100ns;

        wait until rising_edge(Clk);
        TxData <= x"AA";
        TxStart <= '1';

        wait until rising_edge(Clk);
        TxData <= (others => '0');
        TxStart <= '0';
        
        wait;
    end process;

end architecture;