module tubes (
    input clk,
    input reset,
    input card_inserted,
    input pin_entered,
    input pin_correct,
    input [1:0] menu_option,
    input [15:0] withdrawal_amount,
    output reg [15:0] balance,
    output reg [2:0] state,
    output reg card_eject
);

    // State encoding
    parameter IDLE = 3'b000, CHECK_PIN = 3'b001, MAIN_MENU = 3'b010, CHECK_BALANCE = 3'b011, WITHDRAW = 3'b100;

    reg [15:0] initial_balance = 16'h2710; // Initial balance is 10000

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            balance <= initial_balance;
            card_eject <= 0;
        end else begin
            case (state)
                IDLE: begin
                    card_eject <= 0;
                    if (card_inserted) begin
                        state <= CHECK_PIN;
                    end
                end
                CHECK_PIN: begin
                    if (pin_entered) begin
                        if (pin_correct) begin
                            state <= MAIN_MENU;
                        end else begin
                            card_eject <= 1;
                            state <= IDLE;
                        end
                    end
                end
                MAIN_MENU: begin
                    if (menu_option == 2'b01) begin
                        state <= CHECK_BALANCE;
                    end else if (menu_option == 2'b10) begin
                        state <= WITHDRAW;
                    end
                end
                CHECK_BALANCE: begin
                    state <= MAIN_MENU;
                end
                WITHDRAW: begin
                    if (balance >= withdrawal_amount) begin
                        balance <= balance - withdrawal_amount;
                    end
                    state <= MAIN_MENU;
                end
            endcase
        end
    end
endmodule