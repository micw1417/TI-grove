################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"../build/tm4c123g/obj/grove/grove_buzzer.o" \
"../build/tm4c123g/obj/led.o" \
"../build/tm4c123g/obj/main.o" \
"../build/tm4c123g/obj/startup_gcc.o" \
"./msp432/grove/grove_buzzer.obj" \
"./msp432/led.obj" \
"./msp432/main.obj" \
"./msp432/startup_msp432p401r_gcc.obj" \
"./tm4c123g/grove/grove_buzzer.obj" \
"./tm4c123g/led.obj" \
"./tm4c123g/main.obj" \
"./tm4c123g/startup_gcc.obj" \
"../linker/tm4c123g.ld" \
$(GEN_CMDS__FLAG) \
-llibc.a \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include build/tm4c123g/obj/grove/subdir_vars.mk
-include build/tm4c123g/obj/subdir_vars.mk
-include linker/subdir_vars.mk
-include msp432/grove/subdir_vars.mk
-include msp432/subdir_vars.mk
-include tm4c123g/grove/subdir_vars.mk
-include tm4c123g/subdir_vars.mk
-include build/tm4c123g/obj/grove/subdir_rules.mk
-include build/tm4c123g/obj/subdir_rules.mk
-include linker/subdir_rules.mk
-include msp432/grove/subdir_rules.mk
-include msp432/subdir_rules.mk
-include tm4c123g/grove/subdir_rules.mk
-include tm4c123g/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
grove2.out 

EXE_OUTPUTS__QUOTED += \
"grove2.out" 


# All Target
all: $(OBJS) $(LD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "grove2.out"

# Tool invocations
grove2.out: $(OBJS) $(LD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: MSP430 Linker'
	"C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS/bin/cl430" -vmsp -Ooff --use_hw_mpy=none --advice:power=all --define=__MSP430G2253__ -g --printf_support=minimal --diag_warning=225 --diag_wrap=off --display_error_number -z -m"grove2.map" --heap_size=80 --stack_size=80 -i"C:/ti/ccs1281/ccs/ccs_base/msp430/include" -i"C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS/lib" -i"C:/ti/ccs1281/ccs/tools/compiler/ti-cgt-msp430_21.6.1.LTS/include" --reread_libs --diag_wrap=off --display_error_number --warn_sections --xml_link_info="grove2_linkInfo.xml" --use_hw_mpy=none --rom_model -o "grove2.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(EXE_OUTPUTS__QUOTED)
	-$(RM) "msp432\grove\grove_buzzer.obj" "msp432\led.obj" "msp432\main.obj" "msp432\startup_msp432p401r_gcc.obj" "tm4c123g\grove\grove_buzzer.obj" "tm4c123g\led.obj" "tm4c123g\main.obj" "tm4c123g\startup_gcc.obj" 
	-$(RM) "msp432\grove\grove_buzzer.d" "msp432\led.d" "msp432\main.d" "msp432\startup_msp432p401r_gcc.d" "tm4c123g\grove\grove_buzzer.d" "tm4c123g\led.d" "tm4c123g\main.d" "tm4c123g\startup_gcc.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

