----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:48:49 11/17/2023 
-- Design Name: 
-- Module Name:    Convertidor_Display - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Convertidor_Display is
	generic(
	n: integer :=5 -- Definicion de constantes
	);
    Port ( number : in  STD_LOGIC_VECTOR (n-1 downto 0);
				anodo : out STD_LOGIC_VECTOR (3 downto 0);
           HEX0 : out  STD_LOGIC_VECTOR (7 downto 0));
end Convertidor_Display;

architecture Behavioral of Convertidor_Display is
begin
    process(number)
    begin
        case number is
            when "00000" =>
                HEX0 <= "11000000";  -- Representación del número 0 en 7 segmentos
            when "00001" =>
                HEX0 <= "11111001";  -- Representación del número 1 en 7 segmentos
            when "00010" =>
                HEX0 <= "10100100";  -- Representación del número 2 en 7 segmentos
            when "00011" =>
                HEX0 <= "10110000";  -- Representación del número 3 en 7 segmentos
            when "00100" =>
                HEX0 <= "10011001";  -- Representación del número 4 en 7 segmentos
            when "00101" =>
                HEX0 <= "10010010";  -- Representación del número 5 en 7 segmentos
            when "00110" =>
                HEX0 <= "10000010";  -- Representación del número 6 en 7 segmentos
            when "00111" =>
                HEX0 <= "11111000";  -- Representación del número 7 en 7 segmentos
            when "01000" =>
                HEX0 <= "10000000";  -- Representación del número 8 en 7 segmentos
            when "01001" =>
                HEX0 <= "10010000";  -- Representación del número 9 en 7 segmentos
            when "01010" =>
                HEX0 <= "10001000";  -- Representación del número 10 en 7 segmentos
            when "01011" =>
                HEX0 <= "10000011";  -- Representación del número 11 en 7 segmentos
            when "01100" =>
                HEX0 <= "11000110";  -- Representación del número 12 en 7 segmentos
            when "01101" =>
                HEX0 <= "10100001";  -- Representación del número 13 en 7 segmentos
            when "01110" =>
                HEX0 <= "10000110";  -- Representación del número 14 en 7 segmentos
            when "01111" =>
                HEX0 <= "10001110";  -- Representación del número 15 en 7 segmentos
            when others =>
                HEX0 <= "11000000";   -- Si no coincide con ninguno, apaga todos los displays
        end case;
	end process;	
 anodo <= "1110";	
end Behavioral;

