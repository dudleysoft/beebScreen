#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "beebScreen/beebScreen.h"

void waitForKey()
{
    int c;
    _swi(OS_ReadC,_OUT(1),&c);
}

unsigned char buffer[40960];
int pal[] = {
    0x0000,
    0x0018,
    0x8020,
    0x8038,
    0x0840,
    0x0858,
    0x8068,
    0x8878,
    0x4484,
    0x009f,
    0xf0a0,
    0xf0bf,
    0x0fcf,
    0xffff
};

int main(int argc,char *argv[])
{
    printf("BeebScreen Example.\n");
    printf("Press any key to start.");
    fflush(stdout);
    waitForKey();

    beebScreen_Init(2,BS_INIT_DOUBLE_BUFFER);
    beebScreen_SetBuffer(buffer,BS_BUFFER_FORMAT_8BPP,160,256);
    beebScreen_SendPal(pal,16);

    for(int i=0;i<40960;i++)
    {
        buffer[i]=(i/320)&15;
    }

    beebScreen_Flip();
    waitForKey();

    beebScreen_Quit();
}