--include

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY ALU IS
	GENERIC (n : INTEGER := 10);
	PORT (
		A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE struct OF ALU IS
	COMPONENT partA IS
		GENERIC (n : INTEGER := 10);
		PORT (
			A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT partB IS
		GENERIC (n : INTEGER := 10);
		PORT (
			A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT partC IS
		GENERIC (n : INTEGER := 10);
		PORT (
			A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT partD IS
		GENERIC (n : INTEGER := 10);
		PORT (
			A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Cin : IN STD_LOGIC;
			Cout : OUT STD_LOGIC);
	END COMPONENT;
	SIGNAL Cout_temp0, Cout_temp1, Cout_temp2, Cout_temp3 : STD_LOGIC;
	SIGNAL F_temp0, F_temp1, F_temp2, F_temp3 : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
BEGIN
	pA : partA PORT MAP(A, B, F_temp0, S(1 DOWNTO 0), Cin, Cout_temp0);
	pB : partB PORT MAP(A, B, F_temp1, S(1 DOWNTO 0), Cin, Cout_temp1);
	pC : partC PORT MAP(A, B, F_temp2, S(1 DOWNTO 0), Cin, Cout_temp2);
	pD : partD PORT MAP(A, B, F_temp3, S(1 DOWNTO 0), Cin, Cout_temp3);

	Cout <= Cout_temp0 WHEN S(3 DOWNTO 2) = "00"
		ELSE
		Cout_temp1 WHEN S(3 DOWNTO 2) = "01"
		ELSE
		Cout_temp2 WHEN S(3 DOWNTO 2) = "10"
		ELSE
		Cout_temp3;

	F <= F_temp0 WHEN S(3 DOWNTO 2) = "00"
		ELSE
		F_temp1 WHEN S(3 DOWNTO 2) = "01"
		ELSE
		F_temp2 WHEN S(3 DOWNTO 2) = "10"
		ELSE
		F_temp3;
END struct;