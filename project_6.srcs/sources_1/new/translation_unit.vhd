----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 06:05:29 PM
-- Design Name: 
-- Module Name: translation_unit - Behavioral
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

entity translation_unit is
    Port ( pattern_base_index : in STD_LOGIC_VECTOR (3 downto 0);
           offset   :  in STD_LOGIC_VECTOR(3 DOWNTO 0);
           p0_length : in STD_LOGIC_VECTOR (15 downto 0);
           p1_length : in STD_LOGIC_VECTOR (15 downto 0);
           p2_length : in STD_LOGIC_VECTOR (15 downto 0);
           p3_length : in STD_LOGIC_VECTOR (15 downto 0);
           p4_length : in STD_LOGIC_VECTOR (15 downto 0);
           p5_length : in STD_LOGIC_VECTOR (15 downto 0);
           p6_length : in STD_LOGIC_VECTOR (15 downto 0);
           p7_length : in STD_LOGIC_VECTOR (15 downto 0);
           character_address : out STD_LOGIC_VECTOR (15 downto 0));
end translation_unit;

architecture Behavioral of translation_unit is
component adder_16b is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           sum       : out std_logic_vector(15 downto 0);
           carry_out : out std_logic );
end component;

signal p0_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p1_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p2_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p3_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p4_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p5_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p6_offset :  STD_LOGIC_VECTOR (15 downto 0);
signal p7_offset :  STD_LOGIC_VECTOR (15 downto 0);

signal pattern_base_address : std_logic_vector(15 downto 0);
signal offset_16b : std_logic_vector(15 downto 0);

-- not used
signal adder_p1_co  : std_logic;
signal adder_p2_co  : std_logic;
signal adder_p3_co  : std_logic;
signal adder_p4_co  : std_logic;
signal adder_p5_co  : std_logic;
signal adder_p6_co  : std_logic;
signal adder_p7_co  : std_logic;
signal adder_offset_co : std_logic;
begin
    p0_offset <= (others => '0');
    p1_offset <= p0_length;
    adder_p1: adder_16b
    port map( src_a => p1_offset,
              src_b => p1_length,
              sum   =>  p2_offset,
              carry_out => adder_p1_co);
    adder_p2: adder_16b
    port map( src_a => p2_offset,
              src_b => p2_length,
              sum   =>  p3_offset,
              carry_out => adder_p2_co);
    adder_p3: adder_16b
    port map( src_a => p3_offset,
              src_b => p3_length,
              sum   =>  p4_offset,
              carry_out => adder_p3_co);
    adder_p4: adder_16b
    port map( src_a => p4_offset,
              src_b => p4_length,
              sum   =>  p5_offset,
              carry_out => adder_p4_co);
    adder_p5: adder_16b
    port map( src_a => p5_offset,
              src_b => p5_length,
              sum   =>  p6_offset,
              carry_out => adder_p5_co);
    adder_p6: adder_16b
    port map( src_a => p6_offset,
              src_b => p6_length,
              sum   =>  p7_offset,
              carry_out => adder_p6_co);
    
    with pattern_base_index select
        pattern_base_address <= p0_offset when "0000",
                                p1_offset when "0001",
                                p2_offset when "0010",
                                p3_offset when "0011",
                                p4_offset when "0100",
                                p5_offset when "0101",
                                p6_offset when "0110",
                                p7_offset when others;
                                

    offset_16b <= X"000" & offset;
    adder_offset: adder_16b
    port map( src_a => pattern_base_address,
              src_b => offset_16b,
              sum   =>  character_address,
              carry_out => adder_offset_co);                        


end Behavioral;
