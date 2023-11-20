library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Prueba2 is
generic(
	n: integer :=4 -- Definicion de constantes
);
    Port ( A,B,Selector: in  STD_LOGIC_VECTOR (3 downto 0);--Puertos de entrada de A y B y el Selector
           Resultado : out  STD_LOGIC_VECTOR (3 downto 0);--Salida del resultado en bits-leds
			  anodo : out STD_LOGIC_VECTOR (3 downto 0);--Anodo para el display
           HEX0 : out  STD_LOGIC_VECTOR (7 downto 0);--Catodos para el display
			  V : out STD_LOGIC ;--Bandera de desborde
			  S : out STD_LOGIC; --BAndera de signo 1 resta, 0 suma
			  Z : out STD_LOGIC;--Bandera de Cero
			  C : out STD_LOGIC --Bandera de Arrastre
			  );--Me falta la bandera de cero de carry y signo 
end Prueba2;
--Vean los otros archivos de los componentes para que entiendan como funciona cada uno.
--Importante.

architecture Behavioral of Prueba2 is

	------Componente donde se realiza la suma-----------------------------
	component Sumador is
	generic(
	n: integer :=4 -- Definicion de constantes
	);
		 Port ( A, B : in  STD_LOGIC_VECTOR (n-1 downto 0); -- Sumandos
				  Ci : in  STD_LOGIC; -- Acarreo de entrada
				  S : out  STD_LOGIC_VECTOR (n-1 downto 0); -- Suma
				  X : in  STD_LOGIC;
				  Co : out  STD_LOGIC); -- Acarreo de salida
	end component;
	
	------------Compoenente donde se realiza la resta----------------------
	component Convertidor_Display is
	generic(
	n: integer :=5 -- Definicion de constantes
	);

    Port ( number : in  STD_LOGIC_VECTOR (n-1 downto 0);
				anodo : out STD_LOGIC_VECTOR (3 downto 0);
           HEX0 : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	--Estos compoentens funcionan como archivos o proyectos externos que actuan como funciones que reciben y 
	--Devuelven varaibles .
	------Señales de entradas y salida  para los componentes----------------
	signal ResTemporal : STD_LOGIC_VECTOR (n downto 0);
	signal numero1 : STD_LOGIC_VECTOR (n-1 downto 0);--Estos numeros son para la operacion de la suma
	signal numero2 : STD_LOGIC_VECTOR (n-1 downto 0);
	signal numeroAUX : STD_LOGIC_VECTOR (n-1 downto 0);
	signal Temp : STD_LOGIC_VECTOR (n-1 downto 0);
	signal Cin : STD_LOGIC := '0';-- Cin de entrada para la suma
	signal Op : STD_LOGIC := '0';-- Tipo de operacion 0 suma , 1 resta
	signal Carry : STD_LOGIC;-- El Cout de la suma o signo de la resta
	signal Sout	 : STD_LOGIC_VECTOR (n-1 downto 0); -- Resultado de la operacion
	signal AnodoTemp	 : STD_LOGIC_VECTOR (3 downto 0); --Señales de Salida del traductor de binario a hexadecimal
	signal HEXTemp	 : STD_LOGIC_VECTOR (7 downto 0);
	signal Signo : STD_LOGIC; -- Signo del numero resultante de las operaciones
begin
	---Aqui se le denomina instancia cuando se llamn a los programa , siempre estan ejecucion , se cambian sus señales para
	--obtener difernetes resultados uno hace la suma y el otro es el traductor de binario a hexadecimal
	 Display: Convertidor_Display port map ( number=> ResTemporal, anodo=>AnodoTemp, HEX0=>HEXTemp );--Declaro este subprograma para el display
	 SumadorComp: Sumador port map (A => numero1, B => numero2, Ci => Cin, S => Sout, Co => Carry, X=>Op);--Declaro este subprograma para realizar las sumas
    --Inicio de proceso main---------------------------------------------------------------------------------------
	 process(A ,B,Selector, Sout, AnodoTemp, HexTemp, ResTemporal, Carry, numero1, numero2, Cin, Signo, Temp, numeroAUX)
		begin
		Cin <= '0'; --Se reinicia el acarreo por que son pocos los caso que lo utilizan 
		Op <= '0'; --Se reinicia la operacion para hacer suma por que son pocos los caso que lo utilizan 
		Signo <= '0';
		Temp <=(others => '0');
		numeroAUX <=(others => '0');
		ResTemporal<=(others => '0'); ---Se reinicia siempre el resultado par aevitar errores
		case Selector is --selector son los botones les explico funcionan.
			when "0000" =>
				numero1<=(others => '0'); ---En vhdl es necesario declarar todas las posibilidades de cambio de nuestras señales
				numero2<=(others => '0');--Por los que es prioritario aunque no se use asignarla a 0.
				ResTemporal(n-1 downto 0) <= A;
			when "0001" =>
				numero1<=A;
				numero2<="0001";
				if Carry ='1' then -- Verificacion de la señal que devuelve la funcion de suma que nos va inidicar si hay desborde
					ResTemporal<="11111"; --El se leva al maximo por si acaso
				else
					ResTemporal(n-1 downto 0) <= Sout;  --Si no se asigna , este se ve diferente por que es un bit mas grande que lo que 
					--Recibe un bus de bits mas pequeño entonces ay que acomodarla se repite en donde vean este mismo comportamiento.
				end if;
			when "0010" =>
				numero1<=A;
				numero2<=B;
				if Carry ='1' then
					ResTemporal<="11111";
				else
					ResTemporal(n-1 downto 0) <= Sout; 
				end if;
			when "0011" =>
				numero1<=A;
				numero2<=B;
				Cin<='1';
				if Carry ='1' then
					ResTemporal<="11111";
				else
					ResTemporal(n-1 downto 0) <= Sout; 
				end if;
			when "0100" =>--Suma del complemento de B a2
				numero1<=(others => '0');
				numero2<=(others => '0');
				if B = "0000" then 
					V <= '1';
				else
					for i in 0 to n-1 loop
						Temp(i) <= not B(i);
					end loop;
					numero1 <= A;
					numero2 <= Temp;
					if Carry ='1' then
						ResTemporal<="11111";
					else
						ResTemporal(n-1 downto 0) <= Sout; 
					end if;
				end if;
			when "0101" =>--Suma del complemento de B a2 mas el acarreo
				numero1<=(others => '0');
				numero2<=(others => '0');
				if B = "0000" then 
					V <= '1';
				else
					for i in 0 to n-1 loop
						Temp(i) <= not B(i);
					end loop;
					numero1 <= A;
					numero2 <= Temp + "0001";
					--Cin<='1';
					if B > A then
						Signo <= '1';
						for i in 0 to n-1 loop
							numeroAUX(i) <= not Sout(i);
						end loop;
						ResTemporal(n-1 downto 0) <= numeroAUX + "0001";
					else
						Signo <= '0';
						ResTemporal(n-1 downto 0) <= Sout;
					end if;
				end if;
			when "0110" => -- A -1 Decremento
				numero1<=A;
				numero2<="0000";
				Cin<='1';
				Op<='1';
				if Carry ='1' then
					Signo <= '1';
				end if;
				ResTemporal(n-1 downto 0) <= Sout; 
			when "0111" => --Transferencia de B
				numero1<=(others => '0');
				numero2<=(others => '0');
				ResTemporal(n-1 downto 0) <= B; 
			when "1000" => --A and B
				numero1<=(others => '0');
				numero2<=(others => '0');
				ResTemporal(n-1 downto 0) <= A and B; 
			when "1001" => --A or B
				numero1<=(others => '0');
				numero2<=(others => '0');
				ResTemporal(n-1 downto 0) <= A or B; 
			when "1010" => --A xor B
				numero1<=(others => '0');
				numero2<=(others => '0');
				ResTemporal(n-1 downto 0) <= A xor B; 
			when "1011" => --Complemento de A
				numero1<=(others => '0');
				numero2<=(others => '0');
				for i in 0 to n-1 loop
					ResTemporal(i) <= not A(i);
				end loop;
			when others =>
				numero1<=(others => '0');
				numero2<=(others => '0');
				ResTemporal<=(others => '0');
		end case;
		anodo<=AnodoTemp; -- La señal interna a la salida de la nexys del display
		HEX0<=HEXTemp;--Lo mismo que el de arriba
		if ResTemporal(n-1 downto 0) = "0000" then
			Z <= '1';
		else
			Z <= '0';
		end if;
		Resultado <= ResTemporal(n-1 downto 0); --Salida del Resuladto temporal a la nexys
		if Signo = '1' then
			V <= '0';
		else
			V <=Carry; --Definicion por si la bandera esta prendida o apagada
		end if;
		S <= Signo;
		C<= Carry;
	end process;
end Behavioral;

