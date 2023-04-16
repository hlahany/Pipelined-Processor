--include

Library IEEE;
Use ieee.std_logic_1164.all;

entity nbit_adder is 
port( A,B:in std_logic_vector(15 downto 0);
	F:out std_logic_vector(15 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
end entity;

Architecture imp_nbit_adder of nbit_adder is
Component my_nadder is
PORT (a,b : IN  std_logic_vector(1 downto 0);
        cin : in std_logic;
	s : out std_logic_vector(1 downto 0);
        cout : OUT std_logic );
End Component;
Component select_adder is
PORT (a,b : IN  std_logic_vector(1 downto 0);
        cin : in std_logic;
	s : out std_logic_vector(1 downto 0);
        cout : OUT std_logic );
End Component;
signal C: std_logic_vector(8 downto 0);
begin
C(0) <= Cin;
Cout <= C(8);
U1: my_nadder PORT MAP (A(1 downto 0), B(1 downto 0), C(0), F(1 downto 0), C(1));
loop1: FOR i IN 1 TO 7 GENERATE
UX: select_adder PORT MAP (A((2*i+1) downto 2*i), B((2*i+1) downto 2*i), C(i), F((2*i+1) downto 2*i), C(i+1));
END GENERATE;
end imp_nbit_adder;

