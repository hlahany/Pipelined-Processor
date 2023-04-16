LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY ram IS
PORT (Clk : IN std_logic;
En : IN std_logic;
read_address : IN std_logic_vector(1 DOWNTO 0);
write_address : IN std_logic_vector(1 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END ENTITY;

ARCHITECTURE sync_ram_a OF ram IS
TYPE ram_type IS ARRAY(0 TO 3) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;
BEGIN
PROCESS(Clk) IS
BEGIN

IF falling_edge(Clk) THEN
    IF En = '1' THEN
        ram(to_integer(unsigned((write_address)))) <= datain;
    END IF;
END IF;
END PROCESS;
dataout <= ram(to_integer(unsigned((read_address))));
END sync_ram_a;