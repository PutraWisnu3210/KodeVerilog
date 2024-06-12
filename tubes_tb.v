module tubes_tb;

    // Inputs
    reg clk;
    reg reset;
    reg card_inserted;
    reg pin_entered;
    reg pin_correct;
    reg [1:0] menu_option;
    reg [15:0] withdrawal_amount;

    // Outputs
    wire [15:0] balance;
    wire [2:0] state;
    wire card_eject;

    // Instantiate the ATM Machine
    tubes uut (
        .clk(clk),
        .reset(reset),
        .card_inserted(card_inserted),
        .pin_entered(pin_entered),
        .pin_correct(pin_correct),
        .menu_option(menu_option),
        .withdrawal_amount(withdrawal_amount),
        .balance(balance),
        .state(state),
        .card_eject(card_eject)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        card_inserted = 0;
        pin_entered = 0;
        pin_correct = 0;
        menu_option = 2'b00;
        withdrawal_amount = 16'h0000;

        // Apply Reset
        reset = 1;
        #10;
        reset = 0;

        // Test Scenario: Insert card and enter correct PIN
        #10;
        card_inserted = 1;
        #10;
        pin_entered = 1;
        pin_correct = 1;
        #10;
        pin_entered = 0;

        // Test Scenario: Check Balance
        #10;
        menu_option = 2'b01; // Check Balance
        #10;
        menu_option = 2'b00; // Return to Menu

        // Test Scenario: Withdraw Money
        #10;
        menu_option = 2'b10; // Withdraw
        withdrawal_amount = 16'h03E8; // Withdraw 1000
        #10;
        menu_option = 2'b00; // Return to Menu

        // Test Scenario: Exit
        #10;
        card_inserted = 0;
        #50;

        // Test Scenario: Insert card and enter wrong PIN
        #10;
        card_inserted = 1;
        #10;
        pin_entered = 1;
        pin_correct = 0;
        #10;
        pin_entered = 0;

        // End Simulation
        #100;
        $finish;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time=%0d, State=%0b, Card Eject=%b, Balance=%0d", $time, state, card_eject, balance);
    end

endmodule