# Angular Regions - Line Hough Transform (AR-LHT) Implementation on FPGA (arlht2fpga).

This repository contains the dataset used by the publication "FPGA Implementation of a Memory-Efficient Hough Parameter Space for the Detection of Lines" \- Northcote _et al_.

Corresponding publication DOI: [10.1109/ISCAS.2018.8351115] (https://doi.org/10.1109/ISCAS.2018.8351115)

The work contained within this repository, and described in the corresponding publication, is inspired by the research of Pui-Kin Ser and Wan-Chi Siu and their work on "Memory Compression for Straigh Line Recognition using the Hough Transform". 

## How to use this dataset
The dataset for the AR-LHT FPGA implementation is provided as a set of Matlab and Simulink files for simulation and VHDL generation. Images and reports are provided in _.bitmap_ and _.txt_ format respectively. Simulink models and M-files can be opened using Vivado 2018.1 and MATLAB 2018a. System Generator must be configured from Vivado 2018.1 to use MATLAB 2018a, prior to opening any Simulink model. Bitmaps can be opened using any good image viewer and text files can be opened using Notepad++.

There are four folders in this repository. Each are described below:

- **/dataset** \- This directory stores the two images contained in the publication. These images are used to test the ability of the AR-LHT simulation.
- **/hwprj** \- Hardware target models are stored here. In particular, models that have already been tested for VHDL generation and FPGA synthesis and implementation are provided. There are four folders within **/hwprj** that contains seperate models for each tested resolution described in the corresponding publication. Furthermore, each folder contains its own utilisation and timing report produced after FPGA implementation. These reports provide results that are given in the publication. Implementation can be carried out by opening the target model and selecting generate from the System Generator token. This action will create a Vivado project and generate VHDL files. The Vivado project can be opened and implementation can be ran. Further details are provided below in the section named, _FPGA Implementation_.
- **/models** \- The main AR-LHT simulation is found in this location. To run the experiment, run the 'run_simulation.m' script from MATLAB. This script will simulate twice using the images stored in /dataset.
- **/scripts** \- This folder contains several M-files that provide support to the simulation models in this repository.

## Running the AR-LHT simulation
Follow the steps below to open AR-LHT model and run the simulation, as described in Section IV of the corresponding publication.

1. Open System Generator 2018.1.
2. Clone the arlht2fpga repository and navigate to the **/models** folder in the MATLAB workspace.
3. Open and run the **run_simulation.m** script. The script will set a series of parameters related to running the AR-LHT simulation. Further information is provided as comments in the run_simulation.m file.

The simulation will run twice for each image contained in the **/dataset** folder. The output images are provided using imtool once the simulation is finished.

## FPGA Implementation
The ar_lht_hw_target Simulink models within the **/hwprj/ar_lht_xxxx** folders can be used to generate VHDL. The steps below will generate VHDL in System Generator and run synthesis and implementation in Vivado.

1. Open System Generator 2018.1
2. Clone the arlht2fpga repository and navigate to **/hwprj/ar_lht_1024** (or other folder depending on image resolution) in the MATLAB workspace.
3. Open the ar_lht_1024.slx model and update the model by pressing _ctrl+d_ on your keyboard. Double-click on the System Generator token.
4. A window will open. Click-on the __generate__ button and wait for System Generator to finish VHDL generation. If the following error occurs, update the model again and rerun generation. **Internal Error reported by Vivado process :' Too many positional options when parsing \'-force\', please type \'create_project -help\' for usage info.'Error occurred during "HDL Netlist Generation".**
5. In a file explorer window, navigate to **/hwprj/ar_lht_1024/netlist/hdl_netlist** and open the Vivado project file in Vivado 2018.1 (that is, the 'ar_lht_hw_target.xpr' file).
6. Run implementation and wait until Vivado has finished. System reports can be generated using Vivado.

## Additional Notes
* FPGA resource consumption detailed in the corresponding publication is based on the AR-LHT architecture without the morphological opening postprocessing stage and AXI Stream FIFO.
* There may be a minor difference in votes between the AR-LHT hardware simulation and software model. This can be improved by increasing the wordlength of the cosine and sinusoid look-up-tables in the calculate Rho block to 32_30.
* The TVALID signal will not tolerate going low after being high during data transfer i.e.Once TVALID is high, it must stay high. Future work will fix this issue.

