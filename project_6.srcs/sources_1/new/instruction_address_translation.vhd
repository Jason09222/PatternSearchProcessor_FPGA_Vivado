----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 02:31:32 AM
-- Design Name: 
-- Module Name: instruction_address_translation - Behavioral
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

entity instruction_address_translation is
    Port ( current_pc : in STD_LOGIC_VECTOR (7 downto 0);
           mode : in STD_LOGIC;
           real_address : out STD_LOGIC_VECTOR (7 downto 0));
end instruction_address_translation;

architecture Behavioral of instruction_address_translation is
component mux_2to1_8b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(7 downto 0);
           data_b     : in  std_logic_vector(7 downto 0);
           data_out   : out std_logic_vector(7 downto 0) );
end component;
component adder_8b is
    port ( src_a     : in  std_logic_vector(7 downto 0);
           src_b     : in  std_logic_vector(7 downto 0);
           sum       : out std_logic_vector(7 downto 0);
           carry_out : out std_logic );
end component;

constant COMPARE  : std_logic_vector(7 downto 0) := X"00";
constant POOL : std_logic_vector(7 downto 0) := X"F0";

signal offset : std_logic_vector(7 downto 0);
signal adder_co : std_logic;
begin
    with mode select 
        offset <= COMPARE when '0',
                  POOL when others; 
    inst_addr_8b: adder_8b
    port map (  src_a     => current_pc,
                src_b     => offset,
                sum       => real_address,
                carry_out => adder_co ); 
end Behavioral;
