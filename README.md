# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## Please fill in your project documentation in this README.md file 

Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 

## Bloom Filter Counter

## Step 1: Generateion of the Verilog Code using AI Generated Tool
Using [ChatGPT](https://chat.openai.com/):
1. Question Asked: Please create an innovative counter  of completely new type...
Answer:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/edffcfac-1ee6-44e6-8008-6485fb7b4d9f)
2. Question Asked: more complex probablistic counter
Answer:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/5954381f-3fbd-474c-9c6c-7625a42c63af)
3. Explanation given by ChatGPT:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/dfda0c0d-975b-4288-8537-35225cb1f745)
4. Question: Please explain the above counter further and how it is helpful?
Answer:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/89b79f3a-c0f9-4bab-b4b8-e8ef9a6c02b1)
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/d777db96-8ee2-4fd8-9f8b-f89a7afab686)
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/31cb2ebd-5747-48bc-b831-e970647a065f)

Using Bard:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/6b7febac-07af-44b0-b410-27b5cfb749c9)



**However, based on the above answers, we finalized building up a Bloom Filter Counter over the results given by ChatGPT!**

## Step 2: Cloning the Caravel Repo:

```git clone https://github.com/efabless/caravel_user_project```
Some points on Caravel by ChatGPT:
![image](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/9e95e535-26ba-45a4-96e4-afbfd776fb4f)

## Step 3: Embedding the Verilog file to the User_Project_Wrapper

For simplicity, the above [Bloom Counter Generated by ChatGPT](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/verilog/rtl/dvsdfossbfc.v) was Embedded in User_Project_Wrapper.

Here is the code snippet:
```
assign io_oeb[15:0]=16'b1111_1111_1111_1111;
assign io_oeb[`MPRJ_IO_PADS-1:16]=0;
assign io_out=1;
assign la_data_out=1;
assign wbs_dat_o=1;
assign user_irq=1;
reg [15:0] counter;
  reg [15:0] bloomFilter;
always @(posedge user_clock2 or posedge io_in[0]) begin
    if (io_in[0]) begin
      counter <= 16'b0000_0000_0000_0000;
      bloomFilter <= 16'b0000_0000_0000_0000;
    end else if (io_in[9]) begin
      if (bloomFilter[io_in[8:1]]) begin
        // Bloom filter indicates that the input data is likely already counted
        counter <= counter;
      end else begin
        // Bloom filter indicates that the input data is likely not counted
        counter <= counter + 1;
        bloomFilter[io_in[8:1]] <= 1;
      end
    end
  end
  assign io_out[31:16]=counter;
```

The modified code is available [HERE](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/verilog/rtl/user_project_wrapper.v).


