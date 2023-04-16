--include

Library IEEE;
Use ieee.std_logic_1164.all;

entity register_file_mem is 
port(   input_port:in std_logic_vector(15 downto 0);
	read_address:in std_logic_vector(1 downto 0);
	write_address:in std_logic_vector(1 downto 0);
	write_enable:in std_logic;
	Rst: in std_logic;
	Clk: in std_logic;
	output_port:out std_logic_vector(15 downto 0));
end entity;

ARCHITECTURE mem_reg of register_file_mem IS
COMPONENT ram IS
PORT (Clk : IN std_logic;
En : IN std_logic;
Rst: IN std_logic;
read_address : IN std_logic_vector(1 DOWNTO 0);
write_address : IN std_logic_vector(1 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END COMPONENT;
BEGIN
R1: ram PORT MAP (Clk, write_enable, Rst, read_address, write_address, input_port, output_port);
END mem_reg;