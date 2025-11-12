---------------------------------------------------------------------------
-- instruction_memory.vhd - Implementation of A Single-Port, 16 x 16-bit
--                          Instruction Memory.
-- 
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
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

entity instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(31 downto 0) );
end instruction_memory;

architecture behavioral of instruction_memory is

type mem_array is array(0 to 255) of std_logic_vector(31 downto 0);
signal sig_insn_mem : mem_array;

begin
    mem_process: process (reset, addr_in ) is
  
    variable var_insn_mem : mem_array;
    variable var_addr     : integer;
  
  
  
  ------------------ instructions -------------------
--	BNE   R1 R2 imm 	compare reg R1, R2 and branch by PC + 1 + imm(signed)
--	ADD   R1 R2 R3  	add content in R1 and R2 and write to R3
--	SLRi  R1 R2 imm 	left shift content in reg R1 by imm and write to R2
--	SOW   R1 R2 imm	    POA[R1+imm] <- R2
--	STB   R1 X  X	    copy pattern number in R1 into pattern number register (so that R2 in LPA instruction is relative to offset) 
--	LPA   R1 R2 R3	    load pattern character (if R2 < R1, R3 <- PA[R2] and R2++, else R3 <- -1), R1 should be $5
--	LLA   R1 R2 R3	    load pattern length array, same as above, R1 should be $9
--	LOA   R1 R2 R3	    load pattern occurence array, same as above, R1 should be $9
--	MVI	  R1 X  R2	    R2 <- reg_file[R1]
--	END   X  X  X	    signal end of function
--	JP    X  X  imm     jump to PC + 1 + offset
--  LOW	  R1 R2 imm     R2 <- POA[R1+imm]



-- constant OP_ADD     : std_logic_vector(7 downto 0) := X"08";
-- constant OP_BNE     : std_logic_vector(7 downto 0) := X"06"; 
-- constant OP_LA      : std_logic_vector(7 downto 0) := X"0a"; 
-- constant OP_SLRi    : std_logic_vector(7 downto 0) := X"0c"; 
-- constant OP_SOW     : std_logic_vector(7 downto 0) := X"02"; 
-- constant OP_STB     : std_logic_vector(7 downto 0) := X"04"; 
-- constant OP_LPA     : std_logic_vector(7 downto 0) := X"05"; 
-- constant OP_LLA     : std_logic_vector(7 downto 0) := X"07"; 
-- constant OP_LOA     : std_logic_vector(7 downto 0) := X"09"; 
-- constant OP_MVI     : std_logic_vector(7 downto 0) := X"0b"; 
-- constant OP_END     : std_logic_vector(7 downto 0) := X"0d"; 
-- constant OP_JP      : std_logic_vector(7 downto 0) := X"0e"; 
-- constnat OP_LOW     : std_logic_vector(7 downto 0) := X"0f"; 
------------------------------------------------------
    begin
        if (reset = '1') then
            var_insn_mem := (others => X"00000000");
            -- label 1
            var_insn_mem(0):= X"08000006"; -- ADD $0  $0  $6    curr_pattern_num <- 0
            -- label 2
            var_insn_mem(1):= X"04060000"; -- STB $6  0   0	    special_p_register <- curr_pattern_num 
            var_insn_mem(2):= X"08000007"; -- ADD $0  $0  $7    curr_pattern_offset <- 0
            var_insn_mem(3):= X"080b0308"; -- ADD $11 $3  $8    curr_input_base <- input_register_base + chars_processed
            var_insn_mem(4):= X"07090605"; -- LLA $9  $6  $5    curr_pattern_length <- LA[curr_pattern_num], curr_pattern_num++  
            -- label 3
            var_insn_mem(5):= X"0808070c"; -- ADD $8  $7  $12   curr_input_index <- curr_input_base + curr_pattern_offset
            var_insn_mem(6):= X"00000000"; 
            var_insn_mem(7):= X"00000000";
            var_insn_mem(8):= X"00000000"; 
            var_insn_mem(9):= X"0b0c000d"; -- MVI $12 0   $13   i_char <- REG[curr_input_index]
            var_insn_mem(10):= X"05050704"; -- LPA $5  $7  $4    p_char <- PA[p_offset+curr_pattern_offset], curr_pattern_offset++ 
            var_insn_mem(11):= X"060d040a"; -- BNE $13 $4  label 6    if (i_char != p_char) goto label 6
            -- label 4
            var_insn_mem(12)  := X"060705f8";   -- BNE $7  $5  label 3    if (curr_pattern_offset != curr_pattern_length) goto label 3:
            var_insn_mem(13) := X"0f060fff"; -- LOW $6  $15	-1	curr_occurence <- OA[--curr_pattern_num]
            var_insn_mem(14) := X"080f010f"; -- ADD $15 $1  $15 	curr_occurence++	
            var_insn_mem(15) := X"02060fff"; -- SOW $6  $15	-1	OA[--curr_pattern_num] <- curr_occurence 
            -- label 5
            var_insn_mem(16) := X"060609f0"; -- BNE $6  $9	label 2    if (curr_pattern_num != total_number_of_patterns) goto label 2
            var_insn_mem(17) := X"08030103"; -- ADD $3  $1  $3    char_process++
            var_insn_mem(18) := X"06030aed"; -- BNE $3  $10   label 1   if (chars_processed != input_string_length) goto label 1
            var_insn_mem(19) := X"0d000000"; -- END 0   0   0
            var_insn_mem(20) := X"00000000"; -- nop
            var_insn_mem(21) := X"00000000"; -- nop
            -- label 6
            var_insn_mem(22) := X"060e0df9"; -- BNE $14 $13	label 5    if (? != i_char) goto label 5
            var_insn_mem(23) := X"0e0000f4"; -- JP  0	  0 laebl 4    jump to label 4	
        else
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        end if;

        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;
    end process;
  
end behavioral;
