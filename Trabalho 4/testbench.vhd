--    TRABALHO 4 - GERADOR DE IMEDIATOS DO RISC-V
--    Nome: Gustavo Pereira Chaves
--    Matrícula: 19/0014113
--    Disciplina: Organização e Arquitetura de Computadores - Turma C
--    Plataforma Utilizada:
--    Linguagem: VHDL
--    Compilador: MEntor Questa 2020.1
--    IDE: EDA playground

library ieee;
use ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.numeric_std.all;

entity testbench is end;
 
architecture testbench_arch of testbench is

 component genImm32 is
    port (
      instr : in std_logic_vector(31 downto 0);
      imm32 : out signed(31 downto 0)
  	);
 end component;

signal instruction :std_logic_vector(31 downto 0);
signal imm32_out : signed(31 downto 0);

begin
    DUT: genImm32 PORT MAP (instruction, imm32_out);

 estimulo: process
    begin  
        instruction <= x"000002b3";
        wait for 1 ns;
        assert(imm32_out = "0") report "Fail R_Type" severity error; 
        
        instruction <= x"01002283";
        wait for 1 ns;
        assert(imm32_out = 32x"10") report "Fail I_Type0" severity error; 
        
        instruction <= x"f9c00313";
        wait for 1 ns;
        assert(imm32_out = 32x"FFFFFF9C") report "Fail I_Type1" severity error; 
        
        instruction <= x"fff2c293";
        wait for 1 ns;
        assert(imm32_out = 32x"FFFFFFFF") report "Fail I_Type1" severity error; 
        
        instruction <= x"16200313";
        wait for 1 ns;
        assert(imm32_out = 32x"162") report "Fail I_Type1" severity error; 
        
        instruction <= x"01800067";
        wait for 1 ns;
        assert(imm32_out = 32x"18") report "Fail I_Type2" severity error; 
        
        instruction <= x"00002437";
        wait for 1 ns;
        assert(imm32_out = 32x"2000") report "Fail U_Type" severity error; 
        
        instruction <= x"02542e23";
        wait for 1 ns;
        assert(imm32_out = 32x"3C") report "Fail S_Type" severity error; 
        
        instruction <= x"fe5290e3";
        wait for 1 ns;
        assert(imm32_out = 32x"FFFFFFE0") report "Fail SB_Type" severity error; 
        
        instruction <= x"00c000ef";
        wait for 1 ns;
        assert(imm32_out = 32x"C") report "Fail UJ_Type" severity error; 
        
        instruction <= 32x"0";
        
        wait;
        
    end process;
END;
