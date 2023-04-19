LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY CPU IS
    PORT (
        clock, reset, interrupt : IN STD_LOGIC;
        inPort : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        outPort : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE struct OF CPU IS
    -- PC
    SIGNAL pcAddressIn, pcAddressOut : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pcEnable : STD_LOGIC;

    -- Instruction Cache
    SIGNAL instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Fetch Buffer
    SIGNAL fetchBufferEnable : STD_LOGIC;
    SIGNAL fetchBufferOut : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Instruction Decoder
    SIGNAL decoderEnable : STD_LOGIC; -- if 0 then nop is inserted
    SIGNAL decoderSignals : STD_LOGIC_VECTOR(11 DOWNTO 0);

    --- Register File
    SIGNAL WB : STD_LOGIC;
    SIGNAL writeAddress : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL registerFileDataIn : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL registerOut1, registerOut2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- decode buffer
    SIGNAL decodeBufferEnable : STD_LOGIC;
    SIGNAL decodeBufferOut : STD_LOGIC_VECTOR(75 DOWNTO 0);
    SIGNAL decodeBufferDataIn : STD_LOGIC_VECTOR(75 DOWNTO 0);

    -- ALU
    SIGNAL aluSecondOperand : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL aluOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Execute Buffer
    SIGNAL executeBufferEnable : STD_LOGIC;
    SIGNAL executeBufferOut : STD_LOGIC_VECTOR(56 DOWNTO 0);
    SIGNAL executeBufferDataIn : STD_LOGIC_VECTOR(56 DOWNTO 0);

    -- Data Cache
    SIGNAL dataCacheReadAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL dataCacheDataIn, dataCacheDataOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Data Cache Buffer1
    SIGNAL dataCacheBuffer1Enable : STD_LOGIC;
    SIGNAL dataCacheBuffer1DataOut : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL dataCacheBuffer1DataIn : STD_LOGIC_VECTOR(36 DOWNTO 0);

    -- Data Cache Buffer2
    SIGNAL dataCacheBuffer2Enable : STD_LOGIC;
    SIGNAL dataCacheBuffer2DataOut : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL dataCacheBuffer2DataIn : STD_LOGIC_VECTOR(36 DOWNTO 0);

BEGIN
    pcInst : ENTITY work.PC PORT MAP(
        clock => clock,
        enable => pcEnable,
        reset => reset,
        addressIn => pcAddressIn,
        counter => pcAddressOut
    );

    icInst : ENTITY work.InstructionCache PORT MAP(
        readAddress => pcAddressOut,
        dataOut => instruction,
        PCValid => pcEnable,
        PCAddress => pcAddressIn
    ); 

    fetchBufferInst : ENTITY work.StageBuffer GENERIC MAP( n => 32 ) PORT MAP(
        clock => clock,
        reset => reset,
        enable => fetchBufferEnable,
        dataIn => instruction,
        dataOut => fetchBufferOut
    );

    decoderInst : ENTITY work.Decoder PORT MAP(
        enable => decoderEnable,
        opCode => fetchBufferOut(31 DOWNTO 26),
        signals => decoderSignals
    );
    
    writeAddress <= dataCacheBuffer2DataOut(36 DOWNTO 34);
    WB <= dataCacheBuffer2DataOut(32);
    -- TODO: add logic for dataIn from output
    regFileInst : ENTITY work.RegisterFile PORT MAP(
        clock => clock,
        WB => WB,
        Rsrc1 => fetchBufferOut(24 DOWNTO 22),
        Rsrc2 => fetchBufferOut(21 DOWNTO 19),
        Rdst => writeAddress,                   -- logic from output
        dataIn => registerFileDataIn,           -- logic from output
        Rout1 => registerOut1,
        Rout2 => registerOut2
    );

    -- (32bit instruction) (12bits signals) (16 dataout1) (16 dataout2)
    decodeBufferDataIn <= (fetchBufferOut & decoderSignals & registerOut1 & registerOut2);
    decodeBufferInst: ENTITY work.StageBuffer GENERIC MAP( n => 76 ) PORT MAP(
        clock => clock,
        reset => reset,
        enable => decodeBufferEnable,
        dataIn => decodeBufferDataIn,
        dataOut => decodeBufferOut
    );

    -- MUX for ALU second operand
    -- TODO: add logic for forwarding here (FU)
    with decodeBufferOut(75) select
        aluSecondOperand <= 
            decodeBufferOut(59 downto 44) when '1',
            decodeBufferOut(15 downto 0) when OTHERS;



    aluInst: ENTITY work.ALU PORT MAP(
        src1 => decodeBufferOut(31 downto 16),
        src2 => aluSecondOperand,
        opCode => decodeBufferOut(72 downto 70),
        EX => decodeBufferOut(35),
        WALU => decodeBufferOut(39 downto 38), 
        aluOut => aluOut
    );

    -- (3bit Rdst) (2bit stackRW) (1bit IOW) (3bit MEMW, MEMR, WB) (16bit aluOut) (16bit registerOut1) (16bit registerOut2)
    executeBufferDataIn <= (
            decodeBufferOut(68 downto 66) & -- Rdst
            decodeBufferOut(41 downto 40) &
            decodeBufferOut(37) &
            decodeBufferOut(34 downto 32) &
            aluOut &
            decodeBufferOut(31 downto 0)  -- registerOut1 (16bit) & registerOut2 (16bit)
    );

    executeBufferInst: ENTITY work.StageBuffer GENERIC MAP( n => 57 ) PORT MAP(
        clock => clock,
        reset => reset,
        enable => executeBufferEnable,
        dataIn => executeBufferDataIn,
        dataOut => executeBufferOut
    );


    dataCacheInst: ENTITY work.DataCache PORT MAP(
        clock => clock,
        MEMR => executeBufferOut(48),
        MEMW => executeBufferOut(49),
        stackRW => executeBufferOut(53 downto 52),
        readAddress => dataCacheReadAddress, -- logic needed
        dataIn => executeBufferOut(47 downto 32),
        dataOut => dataCacheDataOut 
    );

    -- (3bit Rdst) (1bit IOW) (1bit WB) (16bit aluOut) (DataCacheDataOut)
    dataCacheBuffer1DataIn <=
        executeBufferOut(56 downto 54) &
        executeBufferOut(51) &
        executeBufferOut(48) &
        executeBufferOut(47 downto 32) &
        dataCacheDataOut;
    dataCacheBuffer1Inst: ENTITY work.StageBuffer GENERIC MAP( n => 37 ) PORT MAP(
        clock => clock,
        reset => reset,
        enable => dataCacheBuffer1Enable,
        dataIn => dataCacheBuffer1DataIn,
        dataOut => dataCacheBuffer1DataOut
    );

    dataCacheBuffer2Inst: ENTITY work.StageBuffer GENERIC MAP( n => 37 ) PORT MAP(
        clock => clock,
        reset => reset,
        enable => dataCacheBuffer2Enable,
        dataIn => dataCacheBuffer1DataOut,
        dataOut => dataCacheBuffer2DataOut
    );


END struct;