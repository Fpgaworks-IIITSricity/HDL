module uart__tx (
    input  wire       clk,
    input  wire       resetn,
    input  wire       start,         // pulse to begin sending
    output wire       tx_serial,     // connect to ESP8266 RX
    output reg        busy
);
    parameter CLKS_PER_BIT = 434;

    reg [7:0] rom [0:127];           // holds string to send
    reg [6:0] index;
    reg       tx_start;
    wire      tx_busy, tx_done;
    reg [7:0] tx_byte;

    // Instantiate the UART TX
    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) tx_inst (
        .clk(clk),
        .resetn(resetn),
        .tx_start(tx_start),
        .tx_byte(tx_byte),
        .tx_busy(tx_busy),
        .tx_serial(tx_serial),
        .tx_done(tx_done)
    );

    initial begin
    // ThingSpeak GET request (e.g., GET /update?api_key=XYZ123&field1=28\r\n)
    rom[0]  = "G"; rom[1]  = "E"; rom[2]  = "T"; rom[3]  = " ";
    rom[4]  = "/"; rom[5]  = "u"; rom[6]  = "p"; rom[7]  = "d";
    rom[8]  = "a"; rom[9]  = "t"; rom[10] = "e"; rom[11] = "?";
    
    rom[12] = "a"; rom[13] = "p"; rom[14] = "i"; rom[15] = "_";
    rom[16] = "k"; rom[17] = "e"; rom[18] = "y"; rom[19] = "=";

    //Your API key (replace with yours)STVH35HSX0T9HGKW
    rom[20] = "S"; rom[21] = "T"; rom[22] = "V"; rom[23] = "H";
    rom[24] = "3"; rom[25] = "5"; rom[26] = "H"; rom[27] = "S";
    rom[28] = "X"; rom[29] = "0"; rom[30] = "T"; rom[31] = "9"; 
    rom[32] = "H"; rom[33] = "G"; rom[34] = "K"; rom[35] = "W"; 
    
    
    rom[36] = "&"; rom[37] = "f"; rom[38] = "i"; rom[39] = "e";
    rom[40] = "l"; rom[41] = "d"; rom[42] = "1"; rom[43] = "=";
    rom[44] = "2"; rom[45] = "8"; // Example temp value
    rom[46] = "\r"; rom[47] = "\n";
    rom[48] = 8'h00; // ends transmission

    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            busy     <= 0;
            index    <= 0;
            tx_start <= 0;
        end else begin
            if (start && !busy) begin
                busy     <= 1;
                index    <= 0;
                tx_start <= 1;
                tx_byte  <= rom[0];
            end else if (busy) begin
                tx_start <= 0;
                if (tx_done) begin
                    index <= index + 1;
                    tx_byte <= rom[index + 1];
                    if (rom[index + 1] == 8'h00) begin
                        busy <= 0; // Null terminator means done
                    end else begin
                        tx_start <= 1;
                    end
                end
            end
        end
    end
endmodule
