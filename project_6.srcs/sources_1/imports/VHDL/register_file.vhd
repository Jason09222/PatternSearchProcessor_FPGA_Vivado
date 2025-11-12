---------------------------------------------------------------------------
-- register_file.vhd - Implementation of A Dual-Port, 16 x 16-bit
--                     Collection of Registers.
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


entity register_file is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           register_a : in  std_logic_vector(7 downto 0);
           register_b : in  std_logic_vector(7 downto 0);
           indirect_read_a : in std_logic;
           write_enable    : in  std_logic;
           write_enable2   : in  std_logic;
           write_register  : in  std_logic_vector(7 downto 0);
           write_register2 : in  std_logic_vector(7 downto 0);
           write_data      : in  std_logic_vector(15 downto 0);
           write_data2     : in  std_logic_vector(15 downto 0);
           read_data_a     : out std_logic_vector(15 downto 0);
           read_data_b     : out std_logic_vector(15 downto 0);
           register_a_indir : out std_logic_vector(7 downto 0));
end register_file;

architecture behavioral of register_file is

type reg_file is array(0 to 31) of std_logic_vector(15 downto 0);
signal sig_regfile : reg_file;

begin

    mem_process : process ( reset,
                            clk,
                            register_a,
                            register_b,
                            indirect_read_a,
                            write_enable,
                            write_enable2,
                            write_register,
                            write_register2,
                            write_data,
                            write_data2 ) is

    variable var_regfile     : reg_file;
    variable var_read_addr_a : integer;
    variable var_read_addr_b : integer;
    variable var_write_addr  : integer;
    variable var_write_addr2 : integer;
    variable var_read_addr_a_i : integer;
    
    begin
        
        ---- hardcode --------
        -- total_number_of_patterns = $9 	= 8  
        -- input_string_length 	 = $10 	= 16
        -- input_register_base 	 = $11 	= 16
        -- wildcard			 = $14	= ?
        ------------------------
        -- chars_processed = $3		= i 
        -- curr_pattern_char = $4		p_char	
        -- curr_pattern_length = $5
        -- curr_pattern_num = $6		= j
        -- curr_pattern_offset = $7	= k
        -- curr_input_base = $8 ($8 <- $11 + $3)
        -- curr_input_index = $12 ($12 <- $8 + $7)
        -- curr_input_char = $13		i_char
        -- curr_occurence = $15  

        var_read_addr_a := conv_integer(register_a(4 downto 0));
        var_read_addr_b := conv_integer(register_b(4 downto 0));
        var_write_addr  := conv_integer(write_register(4 downto 0));
        var_write_addr2  := conv_integer(write_register2(4 downto 0));
        
        
        if (reset = '1') then
            -- initial values of the registers - reset to zeroes
            var_regfile := (others => X"0000");
            var_regfile(1) := X"0001";
            var_regfile(2) := X"ffff";
            
            var_regfile(9) := X"0003";  -- total_number_of_patterns
            var_regfile(10) := X"0005"; -- input_string_length
            
            var_regfile(11) := X"0010"; -- input_register_base
            var_regfile(14) := X"00fe"; -- wildcard
            
            var_regfile(16) := X"0001";
            var_regfile(17) := X"0002";
            var_regfile(18) := X"0001";
            var_regfile(19) := X"0002";
            var_regfile(20) := X"0001";
            var_regfile(21) := X"0001";
            var_regfile(22) := X"0002";
            var_regfile(23) := X"0002";
            var_regfile(24) := X"0001";
            var_regfile(25) := X"0001";
            var_regfile(26) := X"0002";
            var_regfile(27) := X"0002";
            var_regfile(28) := X"00e0";
            var_regfile(29) := X"00e0";
            var_regfile(30) := X"00e1";
            var_regfile(31) := X"00e1";
            

        elsif (falling_edge(clk)) then
            if (write_enable = '1') then
                -- register write on the falling clock edge
                var_regfile(var_write_addr) := write_data;
            end if;
            if (write_enable2 = '1') then
                var_regfile(var_write_addr2) := write_data2;         
            end if;
        end if;
        -- enforces special values
        var_regfile(0) := X"0000";
        var_regfile(1) := X"0001";
        var_regfile(2) := X"ffff";
        
        -- continuous read of the registers at location read_register_a
        -- and read_register_b
        -- data_a can be direct or indirect
        if (indirect_read_a = '1') then
            var_read_addr_a_i := conv_integer(var_regfile(var_read_addr_a)(7 downto 0));
            read_data_a <= var_regfile(var_read_addr_a_i); 
            register_a_indir <= var_regfile(var_read_addr_a)(7 downto 0);
        else
            read_data_a <= var_regfile(var_read_addr_a); 
        end if;
        read_data_b <= var_regfile(var_read_addr_b);

        -- the following are probe signals (for simulation purpose)
        sig_regfile <= var_regfile;

    end process; 
end behavioral;
