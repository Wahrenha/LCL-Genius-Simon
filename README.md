# Genius/Simon using Digital circuits

The game Simon (Genius in Brazil) designed using logical circuits and the Hardware Description Language SystemVerilog. The game was implemented in a physical board, as can be seen in this video: https://youtu.be/pwXQbVo5oFY

The game works by generating a pseudorandom sequence of colors, so the subsequent LEDs can be turned on. The player then has 5 seconds to reproduce the exact sequence using the integrated buttons. If the player misses the sequence or the time runs out, the game is over. If the player gets the sequence right he earns 10 points per right color. If the game ends and the player's score is higher than the current record, the record is updated. An integrated buzzer beeps when the colors of the sequence are shown, when the player presses the buttons, and when the game is lost. When the game is over, all the leds in the board flicker and the buzzer beeps repeatedly. 

This project was developed in collaboration with Ph-567 and vitor11-a.

Technologies used:
    Language: SystemVerilog
    Tools:
        -Software Altera Quartus II Web Edition (13.0 SP1 version);
        -FPGA Altera DE2 Development Kit(Chip Cyclone II EP2C35F672C6);
        -Logical kit with a protoboard, LED's and an integrated speaker (buzzer).

The project is divided in the following files:
    beep.sv - Handles the square waves that are sent to the buzzer;
    debounce.sv - Prevents mechanical bouncing in buttons and switches by ensuring the voltage level is stable continously throughout 10ms;
    decoder7.sv - Decodes the 4 bits BCD numbers into the 7 bits used in the display;
    pisca.sv - Turns the LEDs on for a given period of time;
    pontuacao.sv - Increments the score and updates the display;
    recorde.sv - Updates the record when the game is over;
    randomizer.sv - Generates the pseudorandom sequence using LFSR circuits;
    timer_5s.sv - Counts 5 seconds and signals timeout;
    genius_fsm.sv - Handles the Finite State Machine and its state transitions that control the game;
    genius_top - Coordinates all the instances.

How to run:
    Install the Quartus II simulator;
    Clone this repository: git clone [https://github.com/Wahrenha/LCL-Genius-Simon.git](https://github.com/Wahrenha/LCL-Genius-Simon.git) ;
    Open this project;
    Connect the DE2 kit with Quartus II; 
    In assignments -> import pin assignments, import DE2_pin_assignments.csv which is included in the repository, and make sure the pin planner matches the program inputs and outputs;
    Compile genius_top.sv;
    Run the project using the programmer in Quartus.
