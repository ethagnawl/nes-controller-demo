.PHONY : default
default :
	ca65 controller.asm -o controller.o --debug-info
	ld65 controller.o -o controller.nes -t nes --dbgfile controller.dbg 

.PHONY : clean
clean :
	rm -rf controller.nes *.o

.PHONY : run
run : default
	fceux controller.nes
