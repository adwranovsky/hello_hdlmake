# Hello HDLMake
# Intro
This project is an evaluation of the
[hdlmake](https://hdlmake.readthedocs.io/en/master/) tool for use on the
Arty-A7 development board from Digilent. The top module is a simple application
that does the following things:
* Pulses a red LED from one of the RGB LEDs
* Reads in characters at 1,000,000 baud from the USB to UART converter
* Displays the lower 4 bits from the last character read on the UART
* Prints the last character read as fast as possible on the USB to UART converter

# Synthesizing the bitstream
1. Ensure Vivado is installed. I used 2019.2.
2. Prepare a Python 3.7 virtual env. Older versions of Python 3 might work, but
   Python 3.7 is what I use. On my machine I did the following:
```bash
bash> python -m virtualenv --python=$(readlink -f $(which python3.7)) venv
bash> source venv/bin/activate
(venv) bash> pip install six hdlmake git+https://github.com/adwranovsky/buildingblocks.git
```
3. Generate the makefile.
```bash
(venv) bash> cd syn
(venv) bash> hdlmake
```
4. Synthesize the bitstream.
```bash
(venv) bash> make
```
