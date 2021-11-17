"""This file is part of nand2tetris, as taught in The Hebrew University,
and was written by Aviv Yaish according to the specifications given in  
https://www.nand2tetris.org (Shimon Schocken and Noam Nisan, 2017)
and as allowed by the Creative Common Attribution-NonCommercial-ShareAlike 3.0 
Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
"""
import typing

SEGMENTS = {"local": "LCL", "argument": "ARG", "this": "THIS", "that": "THAT", "pointer 0": "R3", "pointer 1": "R4",
            "constant": "CONST", "temp": "TEMP"}
REG_SEGMENTS = {"LCL", "ARG", "THIS", "THAT"}
TEMP = 5

class CodeWriter:
    """Translates VM commands into Hack assembly code."""

    def __init__(self, output_stream: typing.TextIO) -> None:
        """Initializes the CodeWriter.

        Args:
            output_stream (typing.TextIO): output stream.
        """
        self.output = output_stream
        self.true_counter = 0


    def set_file_name(self, filename: str) -> None:
        """Informs the code writer that the translation of a new VM file is 
        started.

        Args:
            filename (str): The name of the VM file.
        """
        # Your code goes here!




    def write_arithmetic(self, command: str) -> None:
        """Writes the assembly code that is the translation of the given 
        arithmetic command.

        Args:
            command (str): an arithmetic command.
        """
        # D = first argument in stack, SP--
        self.output.write("@SP\nM = M - 1\nA = M\nD = M\n")

        if command == "not":
            self.output.write("D = !D\n")
        elif command == "neg":
            self.output.write("D = -D\n")

        else:  # command in ("add", "sub", "eq", "gt", "lt", "and", "or"):
            # M = the next argument in stack
            # self.output.write("@R13\nM = D\n")
            self.output.write("@SP\nM = M - 1\nA = M\n")

            if command == "add":
                self.output.write("D = D+M\n")
            elif command == "sub":
                self.output.write("D = M-D\n")
            elif command == "and":
                self.output.write("D = M&D\n")
            elif command == "or":
                self.output.write("D = M|D\n")
            else:
                self.output.write("@TRUE{0}\nD = D-M\n".format(self.true_counter))
                self.true_counter += 1
                if command == "eq":
                    self.output.write("D;JEQ\n")
                elif command == "gt":
                    self.output.write("D;JGT\n")
                elif command == "lt":
                    self.output.write("D;JLT\n")
                self.output.write("D = 0\n(TRUE)\nD = -1\n")

            # push D to the stack, SP++
            self.output.write("@SP\nA = M\nM = D\n@SP\nM = M+1\n")

    def write_push_pop(self, command: str, segment: str, index: int) -> None:
        """Writes the assembly code that is the translation of the given 
        command, where command is either C_PUSH or C_POP.

        Args:
            command (str): "C_PUSH" or "C_POP".
            segment (str): the memory segment to operate on.
            index (int): the index in the memory segment.
        """

        # local, argument, this, and that

        if command == "C_POP":
            if SEGMENTS[segment] in REG_SEGMENTS:
                # SP-
                self.output.write("@SP\nM = M - 1\n")
                # "*addr = *SP"
                self.output.write("@SP\n"
                                  "A=M\n"
                                  "D=M\n"
                                  "@R13\nM=D\n")

                # R13 = SEGMENTS[segment] + index (the address)"
                self.output.write("@{0}\n"
                                    "D=A\n" \
                                    "@{1}\n" \
                                    "D=M+D\n" \
                                    "@R14\n" \
                                    "M=D\n" \
                                    "@R13\n"\
                                    "D=M\n"\
                                    "@R14\n"\
                                    "A=M\n"\
                                    "M=D\n".format(index, SEGMENTS[segment]))

            elif SEGMENTS[segment] == "TEMP":
                self.output.write("@SP\nM = M - 1\n" \
                "@SP\n" \
                "A=M\n" \
                "D=M\n" \
                "@{0}\n"\
                "M=D\n".format(TEMP + index))


        elif command == "C_PUSH":
            if SEGMENTS[segment] == "CONST":
                # D = index
                self.output.write("@{0}\nD = A\n".format(index))
            elif SEGMENTS[segment] in REG_SEGMENTS:
                # D = *(SEGMENTS[segment] + index)"
                self.output.write("@{0}\nD = M\n@{1}\nA = A+D\nD = M\n".format(SEGMENTS[segment], index))
            elif SEGMENTS[segment] == "TEMP":
                self.output.write("@{0}\n"\
                "D=M\n".format(TEMP + index))

            # *SP = D, SP++
            self.output.write("@SP\nA = M\nM = D\n@SP\nM = M + 1\n")



    def close(self) -> None:
        """Closes the output file."""
        self.output.close()

    # def pop_from_stack(self):

