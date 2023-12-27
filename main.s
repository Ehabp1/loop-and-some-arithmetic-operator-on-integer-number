.intel_syntax noprefix   
# noprefix allows using the registers without %



.section .data
n: .int 0
result: .double 1.0 
outputf: .asciz "the result is %f"
inputf: .asciz "%d"
one: .double 1.0
counter: .double 1.0

.section .text
.global _main
_main:

  # read n from the user
  push OFFSET n   # OFFSET gets the reference
  push OFFSET inputf # reference to the input string
  call _scanf
  # relocate the stack pointer
  # two integers 4 bytes each
  add ESP,4+4 

  # set the loop register to n
  mov ECX , n 


calculationLoop:
  # 1 / denomenator ---- 1/+ 1 -> 1/+ 2 -> 1/+ 3 ........ -> 1 / n 
  FLD QWORD PTR one    # Add the one to the stack
  FDIV QWORD PTR counter
  FILD DWORD PTR n # ADD n to the stack, FILD for integer to fload conversion
  FADD  # n + (1 / x) -> Add n to the value on the top of the stack


  # mutliply the value by the result
  FMUL QWORD PTR result
  FSTP QWORD PTR result   # put the value in the result variable

  # increment the counter
  FLD QWORD PTR counter
  FADD QWORD PTR one
  FSTP QWORD PTR counter

  
  # Decrement n for the next iteration
  sub DWORD PTR n , 1    # DWORD 4 bytes int


  loop calculationLoop  # goto next iteration, decrement loop variable ECX




  # add the  result to the stack  double is 8 bytes
  push [result + 4] # add lowerbits
  push  result  # upperbits
  push OFFSET outputf
  call _printf
  add ESP,4+8
  ret
  ;