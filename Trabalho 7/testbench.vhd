--    TRABALHO 7 - Projeto da Memória de Dados e Instruções
--    Nome: Gustavo Pereira Chaves
--    Matrícula: 19/0014113
--    Disciplina: Organização e Arquitetura de Computadores - Turma C
--    Linguagem: VHDL
--    Compilador: Mentor Questa 2020.1
--    IDE: EDA playground

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;


entity testbench is end;

architecture testbench_arch of testbench is
    component mem_rv is 
    port (
 		clock : in std_logic;
		wren : in std_logic;
 		address : in std_logic_vector(11 downto 0);
 		datain : in std_logic_vector(31 downto 0);
 		dataout : out std_logic_vector(31 downto 0)
    );
    end component;
    constant ram_depth : natural := 4096;
	constant ram_width : natural := 32;
 
	type ram_type is array (0 to ram_depth - 1) of std_logic_vector(ram_width - 1 downto 0);
    
    impure function init_ram_hex (arq : string) return ram_type is
    file text_file : text open read_mode is arq;
    variable text_line : line;
    variable ram_content : ram_type;
    variable i : integer := 0;
    begin
      	while not endfile(text_file) loop
        	readline(text_file, text_line);
        	hread(text_line, ram_content(i));
            i := i + 1;
      	end loop;
  		return ram_content;
	end function;
    
    signal clk :std_logic := '0';
    signal wren :std_logic;
    signal address :std_logic_vector(11 downto 0);
    signal datain :std_logic_vector(31 downto 0);
    signal dataout :std_logic_vector(31 downto 0);
    
    signal text : ram_type := init_ram_hex("text.txt");
    signal data : ram_type := init_ram_hex("data.txt");
begin
	u0: mem_rv PORT MAP (clk, wren, address, datain, dataout);

	clk <= not clk after 1 ns;
    
	estimulo: process
  	begin
        wren <= '1';        
    	for i in 0 to 2048 loop
          address <= std_logic_vector(to_unsigned(i, 12));
          datain <= text(i);
          wait for 2 ns;
        end loop;
                         
    	for i in 2048 to 4096 loop
          address <= std_logic_vector(to_unsigned(i, 12));
          datain <= data(i - 2048);
          wait for 2 ns;
        end loop;

        wait;

  	end process;
    
end testbench_arch;