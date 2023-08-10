
module entry_state(
    input   clk,
    input   reset,

    output  tl_req_ready,
    input   tl_acquireperm_valid,
    input   tl_acquireblock_valid,
    input   tl_release_valid,
    input   tl_releasedata_valid,


    input   tl_channel_b_ready,
    output  tl_probe_valid,

    input   tl_probeack_valid,
    input   tl_probeackdata_valid,


    input   tl_channel_d_ready,
    output  tl_grant_valid,
    output  tl_grantdata_valid,
    output  tl_releaseack_valid,


    input   tl_grantack_valid,




    input   chi_txreq_ready,
    output  chi_txreq_valid,

    input   chi_txrsp_ready,
    output  chi_txrsp_compack_valid,
    output  chi_txrsp_snpresp_valid,

    input   chi_txdat_ready,
    output  chi_txdat_cbwrdata_valid,
    output  chi_txdat_snprespdata_valid,

    input   chi_rxrsp_comp_valid,
    input   chi_rxrsp_compdbidresp_valid,
    input   chi_rxrsp_respsepdata_valid,

    input   chi_rxdat_compdata_valid,
    input   chi_rxdat_datasepresp_valid,

    output  chi_rxsnp_ready,
    input   chi_rxsnp_valid

);



reg chi_expcompack_q;
always @(posedge clk or posedge reset) begin
    if(reset) chi_expcompack_q <= 0;
    else chi_expcompack_q <= 1;
end




/************************************************************
    TileLink Receive and Sent Registers Signals
************************************************************/
reg tl_acquireperm_receive_q;
reg tl_acquireblock_receive_q;
reg tl_release_receive_q;
reg tl_releasedata_receive_q;

reg tl_grant_sent_q;
reg tl_grantdata_sent_q;
reg tl_releaseack_sent_q;
reg tl_grantack_receive_q;

reg tl_probe_sent_q;
reg tl_probeack_receive_q;
reg tl_probeackdata_receive_q;




/************************************************************
    TileLink Pend and Done Signals
************************************************************/
wire tl_probe_pend;
wire tl_grant_pend;
wire tl_grantdata_pend;
wire tl_releaseack_pend;

wire tl_acquireperm_done;
wire tl_acquireblock_done;
wire tl_release_done;
wire tl_releasedata_done;

wire tl_req_receive;
wire tl_req_done;
wire tl_probe_done;





/************************************************************
    CHI Sent and Receive Register Signals
************************************************************/
reg chi_txreq_sent_q;
reg chi_txrsp_compack_sent_q;
reg chi_txdat_cbwrdata_sent_q;

reg chi_rxrsp_comp_receive_q;
reg chi_rxrsp_compdbidresp_receive_q;
reg chi_rxrsp_respsepdata_receive_q;
reg chi_rxdat_compdata_receive_q;
reg chi_rxdat_datasepresp_receive_q;

reg chi_rxsnp_receive_q;
reg chi_txrsp_snpresp_sent_q;
reg chi_txdat_snprespdata_sent_q;





/************************************************************
    CHI Pend and Done Signals
************************************************************/
wire chi_txreq_pend;
wire chi_txrsp_compack_pend;
wire chi_txdat_cbwrdata_pend;

wire chi_snoop_response_pend;
wire chi_txrsp_snpresp_pend;
wire chi_txdat_snprespdata_pend;

wire chi_txreq_done;
wire chi_rxsnp_done;






wire tl_req_chi_txreq_all_done;
wire chi_rxsnp_tl_probe_all_done;

assign tl_req_chi_txreq_all_done = (tl_req_done & chi_txreq_done);
assign chi_rxsnp_tl_probe_all_done = (chi_rxsnp_done & tl_probe_done);





/************************************************************
    TileLink request receive handle
************************************************************/

assign tl_req_ready = ((!tl_req_receive) | tl_req_chi_txreq_all_done);

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_acquireperm_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_acquireperm_receive_q <= 0;
    else if(tl_req_ready & tl_acquireperm_valid)
        tl_acquireperm_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_acquireblock_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_acquireblock_receive_q <= 0;
    else if(tl_req_ready & tl_acquireblock_valid)
        tl_acquireblock_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_release_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_release_receive_q <= 0;
    else if(tl_req_ready & tl_release_valid)
        tl_release_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_releasedata_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_releasedata_receive_q <= 0;
    else if(tl_req_ready & tl_releasedata_valid)
        tl_releasedata_receive_q <= 1;
end





/************************************************************
    TileLink request response and receive handle
************************************************************/

assign tl_grant_valid = tl_grant_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_grant_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_grant_sent_q <= 0;
    else if(tl_channel_d_ready & tl_grant_valid)
        tl_grant_sent_q <= 1;
end


assign tl_grantdata_valid = tl_grantdata_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_grantdata_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_grantdata_sent_q <= 0;
    else if(tl_channel_d_ready & tl_grantdata_valid)
        tl_grantdata_sent_q <= 1;
end



assign tl_releaseack_valid = tl_releaseack_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_releaseack_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_releaseack_sent_q <= 0;
    else if(tl_channel_d_ready & tl_releaseack_valid)
        tl_releaseack_sent_q <= 1;
end





always @(posedge clk or posedge reset) begin
    if(reset)
        tl_grantack_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        tl_grantack_receive_q <= 0;
    else if(tl_grantack_valid)
        tl_grantack_receive_q <= 1;
end










/************************************************************
    TileLink probe handle
************************************************************/

assign tl_probe_valid = tl_probe_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        tl_probe_sent_q <= 0;
    else if(chi_rxsnp_tl_probe_all_done)
        tl_probe_sent_q <= 0;
    else if(tl_channel_b_ready & tl_probe_valid)
        tl_probe_sent_q <= 1;
end


always @(posedge clk or posedge reset) begin
    if(reset)
        tl_probeack_receive_q <= 0;
    if(chi_rxsnp_tl_probe_all_done)
        tl_probeack_receive_q <= 0;
    else if(tl_probeack_valid)
        tl_probeack_receive_q <= 1;
end


always @(posedge clk or posedge reset) begin
    if(reset)
        tl_probeackdata_receive_q <= 0;
    else if(chi_rxsnp_tl_probe_all_done)
        tl_probeackdata_receive_q <= 0;
    else if(tl_probeackdata_valid)
        tl_probeackdata_receive_q <= 1;
end




/************************************************************
    TileLink Slave pend and done Signals handle
************************************************************/
assign tl_probe_pend = chi_rxsnp_receive_q & (!tl_probe_sent_q) & 
                        (
                            (!tl_req_receive) |
                            (!(tl_req_receive & chi_txreq_done & (!tl_req_done)))
                        );

assign tl_grant_pend = tl_acquireperm_receive_q & (!tl_grant_sent_q) & chi_txreq_done;

assign tl_grantdata_pend = tl_acquireblock_receive_q & (!tl_grantdata_sent_q) & chi_txreq_done;

assign tl_releaseack_pend = (tl_release_receive_q | tl_releasedata_receive_q) & (!tl_releaseack_sent_q) & chi_txreq_done;




assign tl_acquireperm_done  = (tl_acquireperm_receive_q & tl_grant_sent_q & tl_grantack_receive_q);
assign tl_acquireblock_done = (tl_acquireblock_receive_q & tl_grantdata_sent_q & tl_grantack_receive_q);
assign tl_release_done      = (tl_release_receive_q & tl_releaseack_sent_q);
assign tl_releasedata_done  = (tl_releasedata_receive_q & tl_releaseack_sent_q);




assign tl_req_receive = (tl_acquireperm_receive_q | tl_acquireblock_receive_q | tl_release_receive_q | tl_releasedata_receive_q);

assign tl_req_done = (tl_acquireperm_done | tl_acquireblock_done | tl_release_done | tl_releasedata_done);

assign tl_probe_done = (tl_probe_sent_q & (tl_probeack_receive_q | tl_probeackdata_receive_q));









/************************************************************
    CHI sent and receive signals handle
************************************************************/
assign chi_txreq_valid = chi_txreq_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_txreq_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_txreq_sent_q <= 0;
    else if(chi_txreq_ready & chi_txreq_valid)
        chi_txreq_sent_q <= 1;
end


assign chi_txrsp_compack_valid = chi_txrsp_compack_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_txrsp_compack_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_txrsp_compack_sent_q <= 0;
    else if(chi_txrsp_ready & chi_txrsp_compack_valid)
        chi_txrsp_compack_sent_q <= 1;
end



assign chi_txdat_cbwrdata_valid = chi_txdat_cbwrdata_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_txdat_cbwrdata_sent_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_txdat_cbwrdata_sent_q <= 0;
    else if(chi_txdat_ready & chi_txdat_cbwrdata_valid)
        chi_txdat_cbwrdata_sent_q <= 1;
end





always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxrsp_comp_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_rxrsp_comp_receive_q <= 0;
    else if(chi_rxrsp_comp_valid)
        chi_rxrsp_comp_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxrsp_compdbidresp_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_rxrsp_compdbidresp_receive_q <= 0;
    else if(chi_rxrsp_compdbidresp_valid)
        chi_rxrsp_compdbidresp_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxrsp_respsepdata_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_rxrsp_respsepdata_receive_q <= 0;
    else if(chi_rxrsp_respsepdata_valid)
        chi_rxrsp_respsepdata_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxdat_compdata_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_rxdat_compdata_receive_q <= 0;
    else if(chi_rxdat_compdata_valid)
        chi_rxdat_compdata_receive_q <= 1;
end

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxdat_datasepresp_receive_q <= 0;
    else if(tl_req_chi_txreq_all_done)
        chi_rxdat_datasepresp_receive_q <= 0;
    else if(chi_rxdat_datasepresp_valid)
        chi_rxdat_datasepresp_receive_q <= 1;
end






assign chi_rxsnp_ready = (!chi_rxsnp_receive_q) | chi_rxsnp_tl_probe_all_done;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_rxsnp_receive_q <= 0;
    else if(chi_rxsnp_tl_probe_all_done)
        chi_rxsnp_receive_q <= 0;
    else if(chi_rxsnp_ready & chi_rxsnp_valid)
        chi_rxsnp_receive_q <= 1;
end



assign chi_txrsp_snpresp_valid = chi_txrsp_snpresp_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_txrsp_snpresp_sent_q <= 0;
    else if(chi_rxsnp_tl_probe_all_done)
        chi_txrsp_snpresp_sent_q <= 0;
    else if(chi_txrsp_ready & chi_txrsp_snpresp_valid)
        chi_txrsp_snpresp_sent_q <= 1;
end



assign chi_txdat_snprespdata_valid = chi_txdat_snprespdata_pend;

always @(posedge clk or posedge reset) begin
    if(reset)
        chi_txdat_snprespdata_sent_q <= 0;
    else if(chi_rxsnp_tl_probe_all_done)
        chi_txdat_snprespdata_sent_q <= 0;
    else if(chi_txdat_ready & chi_txdat_snprespdata_valid)
        chi_txdat_snprespdata_sent_q <= 1;
end








/************************************************************
    CHI pend and done signals handle
************************************************************/

assign chi_txreq_pend = tl_req_receive & (!chi_txreq_sent_q);

assign chi_txrsp_compack_pend = chi_expcompack_q & (!chi_txrsp_compack_sent_q) &  
                                (chi_rxrsp_comp_receive_q | 
                                 chi_rxdat_compdata_receive_q | 
                                 (chi_rxrsp_respsepdata_receive_q & chi_rxdat_datasepresp_receive_q));

assign chi_txdat_cbwrdata_pend = chi_rxrsp_compdbidresp_receive_q & (!chi_txdat_cbwrdata_sent_q);




assign chi_snoop_response_pend = 
    (chi_rxsnp_receive_q & tl_probe_sent_q & (!chi_txrsp_snpresp_sent_q) & (!chi_txdat_snprespdata_sent_q)) & 
    (
        tl_probe_done |
        ((tl_release_receive_q | tl_releasedata_receive_q) & 
            chi_txreq_sent_q & (!tl_releaseack_sent_q))
    );


assign chi_txrsp_snpresp_pend = chi_snoop_response_pend;





assign chi_txreq_done = chi_txreq_sent_q &
                        (
                            ((chi_rxrsp_comp_receive_q |
                              chi_rxdat_compdata_receive_q | 
                              (chi_rxrsp_respsepdata_receive_q & chi_rxdat_datasepresp_receive_q)) & 
                             ((!chi_expcompack_q) | (chi_expcompack_q & chi_txrsp_compack_sent_q))) |
                            (chi_rxrsp_compdbidresp_receive_q & chi_txdat_cbwrdata_sent_q) 
                        );

assign chi_rxsnp_done = chi_rxsnp_receive_q & (chi_txrsp_snpresp_sent_q | chi_txdat_snprespdata_sent_q);




endmodule