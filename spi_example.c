#ifndef F_CPU
#define F_CPU   16000000
#endif
#include<avr/io.h>
#include<util/delay.h>
#include<stdlib.h>

typedef uint8_t byte;

void FlashLED(byte count)
{
    DDRB |= (1 << DDB5);
    for(; count > 0; count--)
    {
        PORTB |= (1 << PORTB5);
        _delay_ms(250);
        PORTB &= ~(1 << PORTB5);
        _delay_ms(250);
    }
}

void SPI_Init()
{
    SPCR = 0x50;
}

void SPI_Close()
{
    SPCR = 0x00;
}

byte SPI_Xfer(byte data)
{
    SPDR = data;
    while(!(SPSR & 0x80)); // note bitwise AND
    return SPDR;
}

void SPI_LoopbackTest()
{
    SPI_Init();
    char i = SPI_Xfer(5);
    SPI_Close();
    FlashLED(i+1);
}

void main()
{
    SPI_LoopbackTest();
}
