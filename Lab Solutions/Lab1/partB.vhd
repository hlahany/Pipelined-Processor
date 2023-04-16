--include

Library IEEE;
Use ieee.std_logic_1164.all;

entity partB is 
generic (n: integer := 10);
port( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
end entity;

Architecture impPartB of partB is
begin
F<= A or B when S= "00" 
else A and B when S="01"
else  A nor B when S="10"
else not A;

Cout<= '0';
end impPartB;
