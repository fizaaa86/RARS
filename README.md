# RARS Programming

This repository contains the RARS programming codes and exercises completed as part of my last-semester coursework.

## About

The programs in this repository are written in **RISC-V Assembly Language** and executed using **RARS (RISC-V Assembler and Runtime Simulator)**.

### A simple RISC-V program:

```asm
.text
.globl main

main:
    li a0, 10
    li a7, 1
    ecall

    li a7, 10
    ecall
```
This program prints the value **10** using a RARS system call.

## Purpose

The purpose of this repository is to document and organize my **RISC-V Assembly programming work** completed during my final semester. It provides a collection of programs implemented using RARS and serves as a reference for practicing and understanding fundamental RISC-V Assembly concepts.
