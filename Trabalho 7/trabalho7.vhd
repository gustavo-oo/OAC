--    TRABALHO 7 - Projeto da Memória de Dados e Instruções
--    Nome Gustavo Pereira Chaves
--    Matrícula 190014113
--    Disciplina Organização e Arquitetura de Computadores - Turma C
--    Linguagem VHDL
--    Compilador Mentor Questa 2020.1
--    IDE EDA playground

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_rv is 
	port (
 		clock  in std_logic;
		wren  in std_logic;
 		address  in std_logic_vector(11 downto 0);
 		datain  in std_logic_vector(31 downto 0);
 		dataout  out std_logic_vector(31 downto 0)
    );
end entity mem_rv;

architecture RTL of mem_rv is

type mem_type is array (0 to (2address'length)-1) of std_logic_vector(datain'range);

signal mem  mem_type;
signal read_address  std_logic_vector(address'range);
  
begin
  sync_process process(clock)
  begin           
    if rising_edge(clock) then
      if wren = '1' then
       	mem(to_integer(unsigned(address))) = datain;
      end if;
     end if;
      read_address = address;
  end process; 
  
  dataout = mem(to_integer(unsigned(read_address)));

end RTL;