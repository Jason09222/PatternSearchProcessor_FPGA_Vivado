----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 06:05:29 PM
-- Design Name: 
-- Module Name: occurence_adder - Behavioral
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

entity occurence_adder is
    Port ( p0_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p1_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p2_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p3_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p4_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p5_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p6_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           p7_occurence : in STD_LOGIC_VECTOR (15 downto 0);
           count : out STD_LOGIC_VECTOR (15 downto 0));
end occurence_adder;

architecture Behavioral of occurence_adder is

-- small components
component adder_16b is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           sum       : out std_logic_vector(15 downto 0);
           carry_out : out std_logic );
end component;

signal temp0 : std_logic_vector(15 downto 0);
signal temp1 : std_logic_vector(15 downto 0);
signal temp2 : std_logic_vector(15 downto 0);
signal temp3 : std_logic_vector(15 downto 0);
signal temp4 : std_logic_vector(15 downto 0);
signal temp5 : std_logic_vector(15 downto 0);
signal temp6 : std_logic_vector(15 downto 0);

signal temp0_c : std_logic;
signal temp1_c : std_logic;
signal temp2_c : std_logic;
signal temp3_c : std_logic;
signal temp4_c : std_logic;
signal temp5_c : std_logic;
signal temp6_c : std_logic;

begin
    adder_t0: adder_16b
    port map( src_a => p0_occurence,
              src_b => p1_occurence,
              sum   => temp0,
              carry_out => temp0_c);
    adder_t1: adder_16b
    port map( src_a => p2_occurence,
              src_b => p3_occurence,
              sum   => temp1,
              carry_out => temp1_c);      
    adder_t2: adder_16b
    port map( src_a => p4_occurence,
              src_b => p5_occurence,
              sum   => temp2,
              carry_out => temp2_c);
    adder_t3: adder_16b
    port map( src_a => p6_occurence,
              src_b => p7_occurence,
              sum   => temp3,
              carry_out => temp3_c);
    adder_t4: adder_16b
    port map( src_a => temp0,
              src_b => temp1,
              sum   => temp4,
              carry_out => temp4_c);
    adder_t5: adder_16b
    port map( src_a => temp2,
              src_b => temp3,
              sum   => temp5,
              carry_out => temp5_c);
    adder_t6: adder_16b
    port map( src_a => temp4,
              src_b => temp5,
              sum   => temp6,
              carry_out => temp6_c);
    count <= temp6;
end Behavioral;
