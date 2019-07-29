SRCS = src/alu.v src/char_def.v src/char_rom.v src/char_test.v src/choice.v src/data_mem.v src/de_reg.v src/decoder.v src/delay_gen.v src/display_top.v src/ee_reg.v src/ew_reg.v src/fd_reg.v src/oled_ctrl.v src/oled_exam.v src/oled_init.v src/pc.v src/processor.v src/reg_file.v src/spi_ctrl.v src/state_def.v src/wregn.v

TARGETS = sim1 sim2 sim3 sim4
VCDS = sim1_pipe.vcd sim2_pipe.vcd sim3_pipe.vcd sim4_pipe.vcd

.PHONY: all clean test

all: $(TARGETS)
test: $(VCDS)

$(TARGETS) : sim% : $(SRCS) src/fetch%.v src/testbench%.v
	iverilog -o $@ $^

$(VCDS) : sim%_pipe.vcd : sim%
	./$<

clean :
	rm -rf sim*
