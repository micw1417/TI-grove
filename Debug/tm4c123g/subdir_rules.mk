################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
tm4c123g/%.obj: ../tm4c123g/%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: MSP430 Compiler'
	"C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS/bin/cl430" -vmsp -Ooff --use_hw_mpy=none --include_path="C:/ti/ccs1281/ccs/ccs_base/msp430/include" --include_path="C:/Users/BobLeBatimont/workspace_v12/grove2" --include_path="C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS/include" --advice:power=all --define=__MSP430G2253__ -g --printf_support=minimal --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="tm4c123g/$(basename $(<F)).d_raw" --obj_directory="tm4c123g" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


