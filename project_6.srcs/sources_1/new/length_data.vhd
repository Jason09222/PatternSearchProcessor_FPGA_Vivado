----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 05:28:43 PM
-- Design Name: 
-- Module Name: character_data - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

---------------------------------------------------------------------------
-- data_memory.vhd - Implementation of A Single-Port, 16 x 16-bit Data
--                   Memory.
-- 
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity length_data is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(15 downto 0);
           addr_in      : in  std_logic_vector(3 downto 0);
           data_out     : out std_logic_vector(15 downto 0);
           p0_length: out std_logic_vector(15 downto 0);
           p1_length: out std_logic_vector(15 downto 0);
           p2_length: out std_logic_vector(15 downto 0);
           p3_length: out std_logic_vector(15 downto 0);
           p4_length: out std_logic_vector(15 downto 0);
           p5_length: out std_logic_vector(15 downto 0);
           p6_length: out std_logic_vector(15 downto 0);
           p7_length: out std_logic_vector(15 downto 0));
end length_data;

architecture behavioral of length_data is
type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal sig_data_mem : mem_array;

begin
    mem_process: process ( reset,
                           clk,
                           write_enable,
                           write_data,
                           addr_in ) is
  
    variable var_data_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        var_addr := conv_integer(addr_in);
        
        if (reset = '1') then
            -- initial values of the data memory : reset to zero 
            var_data_mem := (others => X"0000"); 

        elsif (falling_edge(clk) and write_enable = '1') then
            -- memory writes on the falling clock edge
            var_data_mem(var_addr) := write_data;
        end if;
        
        var_data_mem(0):= X"0001";   
        var_data_mem(1):= X"0003";   
        var_data_mem(2):= X"0003";       
        -- continuous read of the memory location given by var_addr 
        data_out <= var_data_mem(var_addr);
        
        -- output all lengths
        p0_length <= var_data_mem(0);
        p1_length <= var_data_mem(1);
        p2_length <= var_data_mem(2);
        p3_length <= var_data_mem(3);
        p4_length <= var_data_mem(4);
        p5_length <= var_data_mem(5);
        p6_length <= var_data_mem(6);
        p7_length <= var_data_mem(7);
        -- the following are probe signals (for simulation purpose) 
        sig_data_mem <= var_data_mem;

    end process;
  
end behavioral;

