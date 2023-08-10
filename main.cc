#include "main.h"



int main()
{
    InitDUT();
    ResetDUT();

    for(uint32_t i = 0; i < 70; i++)
    {
        if(i == 3) TLAlloc(2);
        if(i == 3) CHIRxSNPSet();

        if(i == 8) CHITxREQReceive();
        if(i == 8) TLChannelBReceive();

        if(i == 11) TLProbeAckSet();
        if(i == 12) CHITxRSPReceive();

        if(i == 15) CHIRxDATSet(1);

        if(i == 16) CHITxRSPReceive();
        if(i == 16) CHIRxSNPSet();


        if(i == 17) TLChannelDReceive();
        if(i == 18) TLGrantAckSet();


        Clock();
    }

    FinishDUT();
    return 0;
}