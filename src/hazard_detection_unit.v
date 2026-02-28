module hazard_detection_unit (
    input        id_ex_mem_read,
    input  [4:0] id_ex_rd,

    input  [4:0] if_id_rs1,
    input  [4:0] if_id_rs2,

    output reg pc_stall,
    output reg if_id_stall,
    output reg id_ex_flush
);

always @(*) begin
    if (id_ex_mem_read &&
       ((id_ex_rd == if_id_rs1) ||
        (id_ex_rd == if_id_rs2))) begin

        pc_stall    = 1;
        if_id_stall = 1;
        id_ex_flush = 1;
    end
    else begin
        pc_stall    = 0;
        if_id_stall = 0;
        id_ex_flush = 0;
    end
end

endmodule
