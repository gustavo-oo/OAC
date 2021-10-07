--    TRABALHO 4 - GERADOR DE IMEDIATOS DO RISC-V
--    Nome: Gustavo Pereira Chaves
--    Matrícula: 19/0014113
--    Disciplina: Organização e Arquitetura de Computadores - Turma C
--    Plataforma Utilizada:
--    Linguagem: VHDL
--    Compilador: MEntor Questa 2020.1
--    IDE: EDA playground

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--Entity (Entidade)
--pinos de entrada e saída

entity genImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out signed(31 downto 0)
  );
end genImm32;

--Architecture (Arquitetura)
--implementacoes do projeto

architecture genImm32_arch of genImm32 is

-- Definição de tipo state que indica os estados possiveis
    type FORMAT_RV is (R_type, I_type, S_type, SB_type, UJ_type, U_type);

-- Sinais auxiliares para armazenar estado atual e mudanças de estado
    signal load_instruction :FORMAT_RV;

-- a definicao inicia por 
begin
    with (instr(6 downto 0)) select
        load_instruction <= R_Type when 7x"33",
                            I_Type when 7x"03" | 7x"13"| 7x"67",
                            S_Type when 7x"23",
                            SB_Type when 7x"63",
                            U_Type when 7x"37",
                            UJ_Type when others;

	with load_instruction select
    	imm32 <= 32x"0" when R_type,
        
        	     resize(signed(instr(31 downto 20)), 32) when I_type,
                 
                 resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32) when S_Type,
                 
                 resize(signed(instr(31 downto 31) & instr(7 downto 7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32) when SB_Type,
                 
                 resize(signed(instr(31 downto 31) & instr(19 downto 12) & instr(20 downto 20) & instr(30 downto 21) & "0"), 32) when UJ_Type,
               
                
				  signed(instr(31 downto 12) & b"000000000000") when others;                 
end genImm32_arch; 

