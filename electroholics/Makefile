CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-Os -DF_CPU=16000000UL -mmcu=atmega328p
PORT=/dev/ttyACM0

#${BIN}.hex: ${BIN}.elf
$(name).hex: $(name).elf
	${OBJCOPY} -O ihex -R .eeprom $< $@

#${BIN}.elf: ${OBJS}
$(name).elf: $(name).o
	${CC} -o $@ $^

install: $(name).hex
	avrdude -F -V -c arduino -p ATMEGA328P -P ${PORT} -b 115200 -U flash:w:$<

clean:
	#rm -f $(name).elf $(name).hex $(name).o
	rm -f *.elf *.hex *.o
