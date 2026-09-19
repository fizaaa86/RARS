RARS Programming

This repository contains the RARS programming codes and exercises completed as part of my last-semester coursework.

About

The programs in this repository are written in RISC-V Assembly Language and executed using RARS (RISC-V Assembler and Runtime Simulator).


A simple RISC-V program:

.text
.globl main

main:
    li a0, 10
    li a7, 1
    ecall

    li a7, 10
    ecall

This program prints the value 10 using a RARS system call.

Purpose
This repository serves as a collection of my RISC-V assembly programming exercises and implementations completed during my final semester. It can also be used as a reference for understanding basic RISC-V assembly concepts and practicing programs using RARS.
