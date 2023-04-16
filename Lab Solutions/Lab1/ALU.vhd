--include

Library IEEE;
Use ieee.std_logic_1164.all;

entity ALU is 
generic (n: integer := 10);
port( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(3 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
end entity;

Architecture struct of ALU is
Component partA is 
generic (n: integer := 10);
port( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
end Component;
Component partB is
generic (n: integer := 10);
port ( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
End Component;
Component partC is
generic (n: integer := 10);
port ( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
End Component;
Component partD is
generic (n: integer := 10);
port ( A,B:in std_logic_vector(n-1 downto 0);
	F:out std_logic_vector(n-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	Cin:in std_logic;
	Cout:out std_logic);
End Component;
signal Cout_temp0, Cout_temp1, Cout_temp2, Cout_temp3: std_logic;
signal F_temp0, F_temp1, F_temp2, F_temp3: std_logic_vector(n-1 downto 0);
begin
pA: partA PORT MAP (A, B, F_temp0, S(1 downto 0), Cin, Cout_temp0);
pB: partB PORT MAP (A, B, F_temp1, S(1 downto 0), Cin, Cout_temp1);
pC: partC PORT MAP (A, B, F_temp2, S(1 downto 0), Cin, Cout_temp2);
pD: partD PORT MAP (A, B, F_temp3, S(1 downto 0), Cin, Cout_temp3);

Cout <= Cout_temp0 when S(3 downto 2) = "00"
else Cout_temp1 when S(3 downto 2) = "01"
else Cout_temp2 when S(3 downto 2) = "10"
else Cout_temp3;

F <= F_temp0 when S(3 downto 2) = "00"
else F_temp1 when S(3 downto 2) = "01"
else F_temp2 when S(3 downto 2) = "10"
else F_temp3;
end struct;





