----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Degtiareva Anastasiia
-- 
-- Create Date: 18.01.2019 01:57:50
-- Design Name: 
-- Module Name: m_fft_module - Behavioral
-- Project Name: fft
-- Target Devices: 
-- Tool Versions: vivado 2018.2
-- Description: 
-- 
-- FFT buterfy. Decimftion in frequency.
-- Input signal width = 32.
-- FFt width can be changed.
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_fft_module is
--  Port ( );
end m_fft_module;

architecture Behavioral of m_fft_module is


-- функция вычисления коэффициентов
-- добавить описание, размерности и т д
function f_w_n_k (  n : in std_logic_vector;
                    k : in std_logic_vector)
return std_logic_vector is
begin
end function f_w_n_k;

begin


end Behavioral;
