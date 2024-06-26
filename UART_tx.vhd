library ieee;
use ieee.std_logic_1164.all;

entity UART_tx is
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
end entity;

architecture rtl of UART_tx is

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

    component BaudClkGenerator is
        generic 
        (
            NUMBER_OF_CLOCKS    : integer;
            SYS_CLK_FREQ        : integer;
            BAUD_RATE           : integer
        );
        port
        (
            Clk     : in std_logic; -- 50MHz
            Rst     : in std_logic;
        
            Start   : in std_logic; -- start counter
            BaudClk : out std_logic; 
            Ready   : out std_logic
        );
    end component;

    signal BaudClk  : std_logic;
    signal TxPacket : std_logic_vector(RS232_DATA_BITS + 1 downto 0);

begin

    TxPacket <= '1' & TxData & '0';

    UART_SERIALISER_INST : Serialiser
        generic map
        (
            DATA_WIDTH  => RS232_DATA_BITS + 2
        )
        port map
        (
            Clk     => Clk,
            Rst     => Rst,
        
            ShiftEn => BaudClk,
            Load    => TxStart,
            Din     => TxPacket,
            Dout    => UART_tx_pin
        );

    UART_BIT_TIMING_INST : BaudClkGenerator
        generic map
        (
            NUMBER_OF_CLOCKS     => RS232_DATA_BITS + 2, -- 1 start bit and 1 stop bit
            SYS_CLK_FREQ         => SYS_CLK_FREQ,
            BAUD_RATE            => BAUD_RATE
        )
        port map
        (
            Clk     => Clk,
            Rst     => Rst,
        
            Start   => TxStart,
            BaudClk => BaudClk,
            Ready   => TxReady
        );

end architecture;