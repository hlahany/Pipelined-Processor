LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PC IS
    GENERIC (N : INTEGER := 16);
    PORT (
        clock, enable, reset: IN STD_LOGIC;
        addressIn: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        counter : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY PC;

ARCHITECTURE myPC OF PC IS
BEGIN
    PROCESS (clock, reset) IS
        -- VARIABLE C : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF reset = '1' THEN
            counter <= (others => '0');
        ELSIF rising_edge(clock) THEN
            IF enable = '1' THEN
                counter <= addressIn;
            END IF;
        END IF;
    END PROCESS;
END myPC;