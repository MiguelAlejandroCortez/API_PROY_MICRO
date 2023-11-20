----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:20:03 11/09/2023 
-- Design Name: 
-- Module Name:    Sumador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM ; 
--use UNISIM.VComponents.all;

entity Sumador is
generic(
n: integer :=4 -- Definicion de constantes
);
    Port ( A, B : in  STD_LOGIC_VECTOR (n-1 downto 0); -- Sumandos
           Ci : in  STD_LOGIC; -- Acarreo de entrada
           S : out  STD_LOGIC_VECTOR (n-1 downto 0); -- Suma
			  X : in  STD_LOGIC;
           Co : out  STD_LOGIC); -- Acarreo de salida
end Sumador;

architecture Behavioral of Sumador is
signal C: STD_LOGIC_VECTOR (n downto 0); --Acarreo Intermedios
signal P: STD_LOGIC_VECTOR (n-1 downto 0); --Complemento de B
signal V: STD_LOGIC_VECTOR (n-1 downto 0); --Inversion
begin
	process(A,B,C,P,V,Ci,X)
	begin 
	V <= (others => X); -- Vector X de n Bits						
	P <= (B XOR V); --Complemento a uno
	C(0)<= (Ci XOR X); --Acarreo de entrada complementado
	for i in 0 to n-1 loop
	S(i) <= (A(i) XOR P(i)) XOR C(i);
	C(i+1) <= ((A(i) AND P(i)) OR (A(i) AND C(i))) OR (P(i) AND C(i));
	end loop;
	Co<=C(n);
	end process;
end Behavioral;

