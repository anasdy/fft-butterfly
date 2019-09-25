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

-----------------------------------------------
-- #Entity
-----------------------------------------------
entity m_fft_module is
-----------------------------------------------
-- #Generic
-----------------------------------------------
    Generic(
        -- FFT width
        C_FFT_WIDTH :   integer := 8;
        -- weight coeficient width
        C_W_WIDTH   :   integer := 8
    );
------------------------------------------------
-- #Port
------------------------------------------------

--  Port ( );
end m_fft_module;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------
-- #architecture
------------------------------------------------
architecture Behavioral of m_fft_module is
    ------------------------------------------------
    -- #f_w_n_k_re function calculate real part of W(n,k)
    -- Where
    --  n =  C_FFT_WIDTH
    --  k = 0 .. (n - 1)  
    -- W(n,k) = exp^(-j*(2pi/n)*k) = cos((2pi/n)*k) + j sin((2pi/n)*k)
    -- Re(W(n,k)) = Re(exp^(-j*(2pi/n)*k)) = cos((2pi/n)*k)
    ------------------------------------------------
    function f_w_n_k_re ( k  : in integer range 0 to C_FFT_WIDTH)
    return std_logic_vector is
    begin
    
    end function f_w_n_k_re;
    
    ------------------------------------------------
    -- #f_w_n_k_im function calculate imaginary part of W(n,k)
    -- Where
    --  n =  C_FFT_WIDTH
    --  k = 0 .. (n - 1)  
    -- W(n,k) = exp^(-j*(2pi/n)*k) = cos((2pi/n)*k) + j sin((2pi/n)*k)
    -- Im(W(n,k)) = Im(exp^(-j*(2pi/n)*k)) = sin((2pi/n)*k)
    ------------------------------------------------
    function f_w_n_k_im ( k  : in integer range 0 to C_FFT_WIDTH)
    return std_logic_vector is
    begin
    
    end function f_w_n_k_im;



------------------------------------------------
-- #Begin
------------------------------------------------
begin


end Behavioral;
