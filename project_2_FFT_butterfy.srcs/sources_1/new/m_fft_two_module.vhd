----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Degtiareva Anastasiia
-- 
-- Create Date: 19.01.2019 18:42:55
-- Design Name: 
-- Module Name: m_fft_two_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: vivado 2018.2
-- Description: 
-- 
-- FFT for 2 sample. 
-- X0 = S0 + S1
-- X1 = (S0 - S1)*W
--
-- Input ports : 
-- Clk - Takt
-- Rst - Reset
-- En - Enable
-- S0 - Sample 0 from input signal
-- S1 - Sample 1 from input signal
-- W -  Weighting factor
--
-- Output ports : 
-- X0 - FFT sample 0
-- X1 - FFT sample 1
-- Rdy - Ready
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-----------------------------------------------
-- #Lib
-----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- convert function
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

---------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------
-- #Entity
-----------------------------------------------
entity m_fft_two_module is

    -----------------------------------------------
    -- #Generic
    -----------------------------------------------
    Generic (
        C_S_WIDTH : integer := 32;
        C_W_WIDTH : integer := 32;
        C_X_WIDTH : integer := 32
    );
        
    -----------------------------------------------
    -- #Port
    -----------------------------------------------
    Port (
        -----------------------------------------------
        -- #Input
        -----------------------------------------------
        Clk : in std_logic;
        Rst : in std_logic;
        
        En  : in std_logic;
        
        -----------------------------------------------
        -- Sample 0 from input signal
        S0  : in std_logic_vector(C_S_WIDTH - 1 downto 0);
        -- Sample 1 from input signal 
        S1  : in std_logic_vector(C_S_WIDTH - 1 downto 0);
        -- Weighting factor
        W   :  in std_logic_vector(C_W_WIDTH - 1 downto 0);
        
        -----------------------------------------------
        -- #Output
        -----------------------------------------------
        --X0 - FFT sample 0
        X0  : out std_logic_vector (C_X_WIDTH - 1 downto 0);
        -- X1 - FFT sample 1
        X1  : out std_logic_vector (C_X_WIDTH - 1 downto 0);
        -- Rdy - Ready
        Rdy : out std_logic
         
    );
end m_fft_two_module;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------
-- #Architecture
-----------------------------------------------

architecture Behavioral of m_fft_two_module is

    -----------------------------------------------
    -- #Signals
    -----------------------------------------------
    -- #Sync_signals - input triggers
    -- #Arith_signals - signal for calculate fft result
    -- #En_signals - enable and ready signals
    
    -- #Sync_signals
    -- triggers for s0, s1
    signal s0_signal    : std_logic_vector(C_S_WIDTH - 1 downto 0);
    signal s1_signal    : std_logic_vector(C_S_WIDTH - 1 downto 0);
    -- trigger for w
    type w_type is array (1 downto 0) of std_logic_vector(C_S_WIDTH - 1 downto 0);
    signal w_signal     : w_type;
    
    -----------------------------------------------
    -- #Arith_signals
    -- X0 = S0 + S1
    type x0_sum_type is array (1 downto 0) of std_logic_vector(C_X_WIDTH - 1 downto 0);
    signal x0_sum : x0_sum_type;
    -- X1 = (S0 - S1)*W
    -- x1_sub = s0 - s1
    signal x1_sub : std_logic_vector(C_X_WIDTH - 1 downto 0);
    -- x1_add = x1_sub*w
    signal x1_add : std_logic_vector(C_X_WIDTH - 1 downto 0);

    -----------------------------------------------
    -- #En_signals
    -- en_rdy_trigger
    -- en_rdy_trigger have width 3 becose scheme have 3 steps: 
    -- input triggers, sum and sub, add sum_out_trigger (sum(1))
    signal en_rdy_trigger : std_logic_vector(2 downto 0);
    
----------------------------------------------------------------------------------   

begin

    X0 <= x0_sum(1);
    X1 <= x1_add;
    Rdy <= en_rdy_trigger(2);

    -----------------------------------------------
    -- #SYNC_PROC
    -----------------------------------------------
    SYNC_PROC : process (Clk, Rst)
    begin
        if rising_edge(CLk) then
            if Rst = '1' then
                s0_signal   <= (others => '0');
                s1_signal   <= (others => '0');
                w_signal    <= (others => (others => '0'));
            else
                s0_signal   <= S0;
                s1_signal   <= S1;
                w_signal(1) <= w_signal(0);
                w_signal(0) <= W;
            end if;
        end if;
    end process; 
    
    -----------------------------------------------
    -- #X0_PROC
    -----------------------------------------------
    X0_PROC : process (Clk, Rst)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                x0_sum  <= (others => (others => '0'));
            else
                -- latency for sync wirh x1
                    x0_sum(1) <= x0_sum(0);
                if en_rdy_trigger(0) = '1' then
                    -- x0 = s0 + s1
                    x0_sum(0) <= SXT(signed(s0_signal) + signed(s1_signal), C_X_WIDTH);
                else
                    x0_sum(0) <= x0_sum(0);
                end if;
            end if;
        end if;
    end process;
    
    -----------------------------------------------
    -- #X1_PROC
    -----------------------------------------------
    X1_PROC : process (Clk, Rst)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                x1_sub <= (others => '0');
                x1_add <= (others => '0');
            else
                if en_rdy_trigger(0) = '1' then
                    -- x1 = (s0 - s1) * w
                    -- x1_sub = so - s1
                    x1_sub  <= SXT(signed(s0_signal) - signed(s1_signal), C_X_WIDTH);
                else
                    x1_sub <= x1_sub;
                end if;
                if en_rdy_trigger(1) = '1' then
                    -- x1_add = x1_sub * w
                    x1_add  <= SXT(signed(x1_sub) * signed(w_signal(1)), C_X_WIDTH);
                else
                    x1_add <= x1_add;
                end if;
            end if;
        end if;
    end process;
    
    -----------------------------------------------
    -- #EN_RDY_PROC
    -----------------------------------------------
    EN_RDY_PROC : process (Clk, Rst)
    begin
        if rising_edge(clk) then
            if Rst = '1' then
                en_rdy_trigger <= (others => '0');
            else
                en_rdy_trigger(0) <= En;
                en_rdy_trigger(1) <= en_rdy_trigger(0);
                en_rdy_trigger(2) <= en_rdy_trigger(1);
            end if;
        end if;
    end process;

end Behavioral;

----------------------------------------------------------------------------------
