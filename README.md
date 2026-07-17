# Genius/Simon Game using Digital Circuits

An FPGA implementation of the classic game **Simon** (known as *Genius* in Brazil), designed using logical circuits and the Hardware Description Language **SystemVerilog**. The system was fully implemented and tested on a physical board, as shown in this [Project Demo Video](https://youtu.be/pwXQbVo5oFY).

---

## 🎮 Game Rules & Logic
* **Sequence Generation:** The game generates a pseudorandom sequence of colors and turns on the corresponding LEDs.
* **Player Input:** The player has **5 seconds** to reproduce the exact sequence using the integrated buttons.
* **Scoring:** The player earns **10 points** per correct color. 
* **High Score Record:** If the player's final score exceeds the current record, the system automatically updates the high score displayed.
* **Audio & Visual Feedback:** 
  * An integrated buzzer active-beeps when showing the sequence, when buttons are pressed, and when the player loses.
  * Upon "Game Over", all board LEDs flicker and the buzzer beeps repeatedly.

---

## 👥 Collaborators
This project was developed in collaboration with [Ph-567](https://github.com/Ph-567) and [vitor11-a](https://github.com/vitor11-a).

---

## 🛠️ Technologies & Hardware Used
* **HDL Language:** SystemVerilog
* **Software:** Altera Quartus II Web Edition (v13.0 SP1)
* **FPGA Board:** Altera DE2 Development Kit (Cyclone II EP2C35F672C6 Chip)
* **Peripherals:** Logic kit containing a breadboard, LEDs, and an integrated active buzzer.

---

## 📂 Project Structure & Modules

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

---

## 🚀 How to Run

1. Install **Quartus II** (v13.0 SP1 recommended for Cyclone II support).
2. Clone this repository:
   ```bash
   git clone [https://github.com/Wahrenha/LCL-Genius-Simon.git](https://github.com/Wahrenha/LCL-Genius-Simon.git)
   ```
3. **Open the project** (`.qpf` file) in Quartus II.
4. **Connect the DE2 FPGA board** to your computer.
5. **Import pin mappings:** Go to `Assignments` -> `Import Assignments...`, select `DE2_pin_assignments.csv` from the cloned repository, and ensure the Pin Planner configuration matches your physical setup.
6. **Compile the top-level entity** `genius_top.sv`.
7. **Upload the compiled `.sof` file** to the board using the **Quartus Programmer** tool.
