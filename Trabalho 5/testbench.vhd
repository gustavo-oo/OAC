--    TRABALHO 5 - BANCO DE REGISTRADORES DO RISC-V
--    Nome: Gustavo Pereira Chaves
--    Matrícula: 19/0014113
--    Disciplina: Organização e Arquitetura de Computadores - Turma C
--    Linguagem: VHDL
--    Compilador: Mentor Questa 2020.1
--    IDE: EDA playground

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;


entity testbench is end;
 
architecture testbench_arch of testbench is
 
    component XREGS is 
      generic (WSIZE : natural := 32);
      port (
        clk, wren, rst : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
      );
    end component;
    
    signal clk  :std_logic := '0';
   	signal wren :std_logic;
    signal rst :std_logic;
    signal rs1, rs2, rd :std_logic_vector(4 downto 0);
    signal data :std_logic_vector(32-1 downto 0);
    signal ro1, ro2 :std_logic_vector(32-1 downto 0);

begin
    u0: XREGS PORT MAP (clk, wren, rst, rs1, rs2, rd, data, ro1, ro2);

 clk <= not clk after 10 ns;

 estimulo: process
    begin        
    	  -- Teste de Leitura e Escrita
          for i in 0 to 31 loop
          	wren <= '1';
            rd <= std_logic_vector(to_unsigned(i, 5));
            data <= std_logic_vector(to_unsigned(i+1, 32));
            
            wait for 20 ns;
            
            wren <= '0';
            rs1 <= std_logic_vector(to_unsigned(i, 5));
            rs2 <= std_logic_vector(to_unsigned(i, 5));
            
            wait for 20 ns;
            
            if i = 0 then
            	assert(ro1 = 32x"0") report "Falha ro1 - Registrador = 0";
          		assert(ro2 = 32x"0") report "Falha ro2 - Registrador = 0";
            else
              assert(ro1 = std_logic_vector(to_unsigned(i+1, 32))) report "Falha ro1 - Registrador =" & integer'image(i);
              assert(ro2 = std_logic_vector(to_unsigned(i+1, 32))) report "Falha ro2 - Registrador =" & integer'image(i);
            end if;
          end loop;
          
          -- Teste Reset
          rst <= '1';
          
          wait for 20 ns;
          
          rst <= '0';
          
          for i in 0 to 31 loop
          	rs1 <= std_logic_vector(to_unsigned(i, 5));
            rs2 <= std_logic_vector(to_unsigned(i, 5));
            
            wait for 20 ns;
            
            assert(ro1 = 32x"0") report "Falha Reset ro1 - Registrador = " & integer'image(i);
            assert(ro2 = 32x"0") report "Falha Reset ro2 - Registrador = " & integer'image(i);
            
          end loop;
          
        wait;
    end process;
    
end testbench_arch;


