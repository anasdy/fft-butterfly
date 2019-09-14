----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2019 15:12:54
-- Design Name: 
-- Module Name: tb_fft_two_module - Behavioral
-- Project Name: fft
-- Target Devices: 
-- Tool Versions: vivado 2018.2
-- Description: 
-- 
-- TestBench for m_fft_two_module
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
-- convert function
use IEEE.std_logic_arith.all;
-- use IEEE.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
entity tb_fft_two_module is
--  Port ( );
end tb_fft_two_module;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

architecture Behavioral of tb_fft_two_module is

    -----------------------------------------------
    -- #component
    -----------------------------------------------
    COMPONENT m_fft_two_module is
    Generic (
        C_S_WIDTH : integer := 32;
        C_W_WIDTH : integer := 32;
        C_X_WIDTH : integer := 32
    );
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
    END COMPONENT;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

    -----------------------------------------------
    -- #constants from module
    -----------------------------------------------
    constant C_S_WIDTH : integer := 32;
    constant C_W_WIDTH : integer := 32;
    constant C_X_WIDTH : integer := 32;
    constant Clk_period : time := 20 ns;
    
    -----------------------------------------------
    -- #signals from module
    -----------------------------------------------
    -- #Input
    -----------------------------------------------
    signal Clk : std_logic := '0';
    signal Rst : std_logic := '0';
    
    signal En  : std_logic := '0';
    
    -----------------------------------------------
    -- Sample 0 from input signal
    signal S0 : std_logic_vector(C_S_WIDTH - 1 downto 0) := (others => '0');
    -- Sample 1 from input signal 
    signal S1 : std_logic_vector(C_S_WIDTH - 1 downto 0) := (others => '0');
    -- Weighting factor
    signal W  : std_logic_vector(C_W_WIDTH - 1 downto 0) := (others => '0');
    
    -----------------------------------------------
    -- #Output
    -----------------------------------------------
    --X0 - FFT sample 0
    signal X0  : std_logic_vector (C_X_WIDTH - 1 downto 0);
    -- X1 - FFT sample 1
    signal X1  : std_logic_vector (C_X_WIDTH - 1 downto 0);
    -- Rdy - Ready
    signal Rdy : std_logic;
    
    -----------------------------------------------
    -- #tb_constants
    -----------------------------------------------
    -- RST
    -- rst_cntr max
    constant c_rst_countr_max : integer := 30;
    -- rst risint endge
    constant c_rst_rising : integer := 10;
    -- rst risint endge
    constant c_rst_falling : integer := 20;
    
    -- EN
    -- en_cntr_max
    constant c_en_cntr_max : integer := 3;
    
    -----------------------------------------------
    -- #tb_counters
    -----------------------------------------------
    -- counter for rst. Wile rst_cntr < c_rst_rising => Rst = 0, 
    -- if rst_cntr = c_rst_rising and rst_cntr < c_rst_rising => Rst = 1, 
    -- if rst_cntr >= c_rst_rising => Rst = 0. 
    -- It works if RST_PROC commeted!!!!!
    signal rst_cnt : integer range 0 to 30 := 0;
    -- counter for En.
    -- Wile en_cntr < c_en_cntr_max => En = 1
    signal en_cntr : integer range 0 to 30 := 0;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

begin
    -----------------------------------------------
    -- #m_fft_two_module
    -----------------------------------------------
     inst_fft_two_module : m_fft_two_module
    -----------------------------------------------
    -- #Generic
    -----------------------------------------------
    Generic map (
        C_S_WIDTH => C_S_WIDTH,
        C_W_WIDTH => C_W_WIDTH,
        C_X_WIDTH => C_X_WIDTH
    )
        
    -----------------------------------------------
    -- #Port
    -----------------------------------------------
    Port map (
        -----------------------------------------------
        -- #Input
        -----------------------------------------------
        Clk => Clk,
        Rst => Rst,
        
        En => En,
        
        -----------------------------------------------
        -- Sample 0 from input signal
        S0 => S0,
        -- Sample 1 from input signal 
        S1 => S1,
        -- Weighting factor
        W  => W,
        
        -----------------------------------------------
        -- #Output
        -----------------------------------------------
        --X0 - FFT sample 0
        X0  => X0,
        -- X1 - FFT sample 1
        X1  => X1,
        -- Rdy - Ready
        Rdy => Rdy
    );

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


    -----------------------------------------------
    -- #CLK_PROC
    -----------------------------------------------
    CLK_PROC : process
    begin
        wait for Clk_period / 2;
        Clk <= not Clk;
    end process;
    
    -----------------------------------------------
    -- #RST_PROC
    -----------------------------------------------
    -- uncomment if you need haven't dependence between Clk and Rst
    -- comment Rst in SIM_PROC
--    RST_PROC : process
--    begin
--        wait for 33 ns;
--        Rst <= '1';
--        wait for Clk_period * 10;
--        Rst <= '0';
--        wait;
--    end process;
    
    -----------------------------------------------
    -- #SIM_PROC
    -----------------------------------------------
    SIM_PROC : process (Clk)
    begin
    -----------------------------------
         -- reset
        if (rst_cnt = c_rst_rising) then
            Rst <= '1';
        elsif (rst_cnt = c_rst_falling) then
            Rst <= '0';
        end if;
        
    -----------------------------------
        if rising_edge(Clk) then
                    
            -- rst_cntr
            if (rst_cnt < c_rst_countr_max) then
                rst_cnt <= rst_cnt + 1;
            else
                rst_cnt <= rst_cnt;
            end if;
        -----------------------------------
            -- simulate
            
            -- en_cntr
            -- En rising only first.
            if (en_cntr < c_en_cntr_max and rst_cnt = c_rst_countr_max) then
                en_cntr <= en_cntr + 1;
                En <= '1';
            else
                en_cntr <= en_cntr;
                En <= '0';
            end if;
                       
            -----------------------------------
            if (en_cntr < c_en_cntr_max and rst_cnt = c_rst_countr_max) then
                for i in 0 to 10 loop            
                    S0 <= SXT(signed(S0) + conv_signed(1, C_S_WIDTH), C_S_WIDTH);
                    S1 <= SXT(signed(S1) + conv_signed(i, C_S_WIDTH), C_S_WIDTH);
                    W  <= conv_std_logic_vector(i, C_W_WIDTH);
                end loop;
            else
                S0 <= S0;
                S1 <= S1;
                W  <= W;
            end if;
            
        end if;
    end process;
    
    

end Behavioral;
