# Genius/Simon Game using Digital Circuits

An FPGA implementation of the classic game **Simon** (known as *Genius* in Brazil), designed using logical circuits and the Hardware Description Language **SystemVerilog**. The system was fully implemented and tested on a physical board, as shown in this [Project Demo Video](https://youtu.be/pwXQbVo5oFY).

The game works by generating a pseudorandom sequence of colors, so the subsequent LEDs can be turned on. The player then has 5 seconds to reproduce the exact sequence using the integrated buttons. If the player misses the sequence or the time runs out, the game is over. If the player gets the sequence right he earns 10 points per right color. If the game ends and the player's score is higher than the current record, the record is updated. An integrated buzzer beeps when the colors of the sequence are shown, when the player presses the buttons, and when the game is lost. When the game is over, all the leds in the board flicker and the buzzer beeps repeatedly. 

This project was developed in collaboration with [Ph-567](https://github.com/Ph-567) and [vitor11-a](https://github.com/vitor11-a).

Technologies & Hardware Used:

* **HDL Language:** SystemVerilog
* **Software:** Altera Quartus II Web Edition (v13.0 SP1)
* **FPGA Board:** Altera DE2 Development Kit (Cyclone II EP2C35F672C6 Chip)
* **Peripherals:** Logic kit containing a breadboard, LEDs, and an integrated active buzzer.

Project Structure & Modules:

The architecture is modular and divided into the following files:
* **`beep.sv`**: Generates and handles the square waves sent to the audio buzzer.
* **`debounce.sv`**: Prevents mechanical bouncing in buttons and switches by ensuring voltage stability continuously for over 10ms.
* **`decoder7.sv`**: Decodes 4-bit BCD numbers into the 7-segment display output.
* **`pisca.sv`**: Controls and times the active state duration of the LEDs.
* **`pontuacao.sv`**: Increments the player's score and dynamically updates the 7-segment displays.
* **`recorde.sv`**: Evaluates, updates, and saves the new high score when the game ends.
* **`randomizer.sv`**: Generates the pseudorandom color sequences utilizing a Linear-Feedback Shift Register (LFSR) circuit.
* **`timer_5s.sv`**: Tracks the 5-second action window and asserts a timeout signal when time runs out.
* **`genius_fsm.sv`**: The Finite State Machine (FSM) that controls the central game state transitions.
* **`genius_top.sv`**: The top-level entity coordinating and instantiating all other sub-modules.

How to Run:

1. Install **Quartus II** (v13.0 SP1 recommended for Cyclone II support).
2. Clone this repository:
   ```bash
   git clone [https://github.com/Wahrenha/LCL-Genius-Simon.git](https://github.com/Wahrenha/LCL-Genius-Simon.git)
'
   Open this project;
    Connect the DE2 kit with Quartus II; 
    In assignments -> import pin assignments, import DE2_pin_assignments.csv which is included in the repository, and make sure the pin planner matches the program inputs and outputs;
    Compile genius_top.sv;
    Upload the compiled .sof file to the board using the Quartus Programmer;
    Run the project.
