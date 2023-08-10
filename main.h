#include "Vstate.h"

#include <verilated.h>
#include <verilated_vcd_c.h>

#include <stdio.h>
#include <stdint.h>


using namespace std;




// Global
Vstate *dut;
VerilatedVcdC *m_trace;
uint32_t clk_count;











void ClockZero(uint32_t num = 1)
{
    for(uint32_t i = 0; i < num; i++)
    {
        dut->clk = 0; dut->eval(); m_trace->dump(clk_count++);
    }
}


void ClockOne(uint32_t num = 1)
{
    for(uint32_t i = 0; i < num; i++)
    {
        dut->clk = 1; dut->eval(); m_trace->dump(clk_count++);
    }
}


void Clock()
{
    ClockZero();
    ClockZero();
    ClockOne();
    ClockOne();
}






void InitDUT()
{
    dut = new Vstate();

    Verilated::traceEverOn(true);
    m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd"); 

    clk_count = 0;
}



void ResetDUT()
{
    dut->reset = 1;
    for(uint32_t i = 0; i < 5; i++)
    {
        ClockZero();
        ClockZero();
        ClockOne();
        ClockOne();
    }
    dut->reset = 0;
}



void FinishDUT()
{
    m_trace->close();
    delete dut;

    printf(" [handle.sv] - Simulator SUCCESS!\n");
}







void TLAlloc(uint32_t req_num)
{
    ClockZero();
    dut->tl_acquireperm_valid  = (req_num == 1);
    dut->tl_acquireblock_valid = (req_num == 2);
    dut->tl_release_valid      = (req_num == 3);
    dut->tl_releasedata_valid  = (req_num == 4);
    ClockZero();
    ClockOne();
    dut->tl_acquireperm_valid  = 0;
    dut->tl_acquireblock_valid = 0;
    dut->tl_release_valid      = 0;
    dut->tl_releasedata_valid  = 0;
    ClockOne();
}

void TLChannelBReceive()
{
    ClockZero();
    dut->tl_channel_b_ready = true;
    ClockZero();
    ClockOne();
    dut->tl_channel_b_ready = false;
    ClockOne();
}

void TLProbeAckSet()
{
    ClockZero();
    dut->tl_probeack_valid = true;
    ClockZero();
    ClockOne();
    dut->tl_probeack_valid = false;
    ClockOne();
}





void TLChannelDReceive()
{
    ClockZero();
    dut->tl_channel_d_ready = true;
    ClockZero();
    ClockOne();
    dut->tl_channel_d_ready = false;
    ClockOne();
}


void TLGrantAckSet()
{
    ClockZero();
    dut->tl_grantack_valid = true;
    ClockZero();
    ClockOne();
    dut->tl_grantack_valid = false;
    ClockOne();
}









void CHITxREQReceive()
{
    ClockZero();
    dut->chi_txreq_ready = true;
    ClockZero();
    ClockOne();
    dut->chi_txreq_ready = false;
    ClockOne();
}

void CHITxRSPReceive()
{
    ClockZero();
    dut->chi_txrsp_ready = true;
    ClockZero();
    ClockOne();
    dut->chi_txrsp_ready = false;
    ClockOne();
}

void CHITxDATReceive()
{
    ClockZero();
    dut->chi_txdat_ready = true;
    ClockZero();
    ClockOne();
    dut->chi_txdat_ready = false;
    ClockOne();
}


void CHIRxRSPSet(uint32_t rsp_num)
{
    ClockZero();
    dut->chi_rxrsp_comp_valid         = (rsp_num == 1);
    dut->chi_rxrsp_compdbidresp_valid = (rsp_num == 2);
    dut->chi_rxrsp_respsepdata_valid  = (rsp_num == 3);
    ClockZero();
    ClockOne();
    dut->chi_rxrsp_comp_valid         = false;
    dut->chi_rxrsp_compdbidresp_valid = false;
    dut->chi_rxrsp_respsepdata_valid  = false;
    ClockOne();
}


void CHIRxDATSet(uint32_t dat_num)
{
    ClockZero();
    dut->chi_rxdat_compdata_valid     = (dat_num == 1);
    dut->chi_rxdat_datasepresp_valid  = (dat_num == 2);
    ClockZero();
    ClockOne();
    dut->chi_rxdat_compdata_valid     = false;
    dut->chi_rxdat_datasepresp_valid  = false;
    ClockOne();
}


void CHIRxSNPSet()
{
    ClockZero();
    dut->chi_rxsnp_valid = true;
    ClockZero();
    ClockOne();
    dut->chi_rxsnp_valid = false;
    ClockOne();
}