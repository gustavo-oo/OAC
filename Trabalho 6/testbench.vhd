library ieee;
use ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.numeric_std.all;

entity testbench is end;
 
architecture testbench_arch of testbench is

 component ulaRV is
    generic (WSIZE : natural := 32);
    port (
      opcode : in std_logic_vector(3 downto 0);
      A, B : in std_logic_vector(WSIZE-1 downto 0);
      Z : out std_logic_vector(WSIZE-1 downto 0);
      cond : out std_logic
    );
 end component;

signal opcode :std_logic_vector(3 downto 0);
signal A, B :std_logic_vector(32-1 downto 0);
signal Z :std_logic_vector(32-1 downto 0);
signal cond :std_logic;

begin
    DUT: ulaRV PORT MAP (opcode, A, B, Z, cond);

 estimulo: process
    begin  
    	-- Teste ADD
    	A <= 32x"10"; 
        B <= 32x"45";
        opcode <= "0000";
        wait for 1 ns;
        assert(Z = 32x"55") report "ERRO ADD Positivo";
        
        A <= 32x"A";
        B <= x"FFFFFFF6";
        wait for 1 ns;
        assert(Z = 32x"0") report "ERRO ADD Zero";
        
        
        A <= x"FFFFFFF1";
        B <= 32x"5";
        wait for 1 ns;
        assert(Z = x"FFFFFFF6") report "ERRO ADD Negativo";
        
        -- Teste SUB
        A <= 32x"5"; 
        B <= x"FFFFFFFB";
        opcode <= "0001";
        wait for 1 ns;
        assert(Z = 32x"A") report "ERRO SUB Positivo";
        
        A <= 32x"3";
        B <= 32x"5";
        wait for 1 ns;
        assert(Z = x"FFFFFFFE") report "ERRO SUB Negativo";
        
        A <= 32x"AE3";
        B <= 32x"AE3";
        wait for 1 ns;
        assert(Z = 32x"0") report "ERRO SUB Zero";
        
        --Teste AND
        A <= 32x"5932";
        B <= 32x"AFE4";
        opcode <= "0010";
        wait for 1 ns;
        assert(Z = 32x"920") report "ERRO AND";

        opcode <= "0011";
        wait for 1 ns;
        assert(Z = 32x"FFF6") report "ERRO OR";
        
        opcode <= "0100";
        wait for 1 ns;
        assert(Z = 32x"f6d6") report "ERRO XOR";
       
        B <= 32x"5";
        opcode <= "0101";
        wait for 1 ns;
        assert(Z = 32x"b2640") report "ERRO Shift Left";
        
        opcode <= "0110";
        wait for 1 ns;
        assert(Z = 32x"2c9") report "ERRO Shift Right Unsigned";
        
        A <= x"fffffffA";
        opcode <= "0111";
        wait for 1 ns;
        assert(Z = x"ffffffff") report "ERRO Shift Right Signed";
        
        A <= x"ffffff56";
        B <= 32x"1";
        opcode <= "1000";
        wait for 1 ns;
        assert(cond = '1') report "ERRO SLT";
        
        opcode <= "1001";
        wait for 1 ns;
        assert(cond = '0') report "ERRO SLTU";
        
        opcode <= "1010";
        wait for 1 ns;
        assert(cond = '0') report "ERRO SGE";
        
        opcode <= "1011";
        wait for 1 ns;
        assert(cond = '1') report "ERRO SGEU";
        
        A <= 32x"32";
        B <= 32x"32";
        opcode <= "1100";
        wait for 1 ns;
        assert(cond = '1') report "Erro SEQ";
        
        opcode <= "1101";
        wait for 1 ns;
        assert(cond = '0') report "Erro SNEQ";
            
		opcode <= "1111";
        wait;
        
    end process;
END;
