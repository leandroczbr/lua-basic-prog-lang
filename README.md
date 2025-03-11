# lua-basic-prog-lang
(VERY) Simple programming language made in lua, designed for client tasks/plugins inside the lua environment.

# Instalation
* Install lua on your computer
* Insert the path the module is located in ```package.path``` 
* add ```require "luabasic-pl.lua"``` to your code

# Example
Here we have a code that prints the fibonacci sequence until the 10th number:

```
set first 0;
    set second 1;
    set next 0;
    add next first second;
    print first;
    print second;
    print next;
    
    set index 0;
    set max 10;
    set continue true;
    :loop
        set first second;
        set second next;
        set next 0;
        add next first second;
        print next;
        add index 1;
        big continue max index;
    ifgt continue loop;
```
Notice I made a for loop using ```set``` for setting the 'for loop' values, ```big``` for checking the 'for loop' limit and ```ifgt``` for making the loop itself.

# Commands

## add
one argument:
| lbpl | equivalent |
|--|--|
| ```add var num1;``` |  ```var += num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```add var num1 num2 ... ; ``` |  ```var = num1 + num2 + ... ``` |

## sub
one argument:
| lbpl | equivalent |
|--|--|
| ```sub var num1;``` |  ```var -= num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```sub var num1 num2 ... ; ``` |  ```var = num1 - num2 - ... ``` |


## mul
one argument:
| lbpl | equivalent |
|--|--|
| ```mul var num1;``` |  ```var *= num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```mul var num1 num2 ... ; ``` |  ```var = num1 * num2 * ... ``` |

## div
one argument:
| lbpl | equivalent |
|--|--|
| ```div var num1;``` |  ```var /= num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```div var num1 num2 ... ; ``` |  ```var = num1 / num2 / ... ``` |

## equ
one argument:
| lbpl | equivalent |
|--|--|
| ```equ var num1;``` |  ```var = var == num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```equ var num1 num2 ... ; ``` |  sets ```var``` whether all values are equal to var or not |

## not
one argument:
| lbpl | equivalent |
|--|--|
| ```not var num1;``` |  ```var = var ~= num1``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```not var num1 num2 ... ; ``` |  sets ```var``` whether all values are different from var or not |

## big
one argument:
| lbpl | equivalent |
|--|--|
| ```big var num1;``` |  ```var = var > num1``` |

two arguments:

| lbpl | equivalent |
|--|--|
| ```big var num1 num2;``` |  ```var = num1 > num2``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```not var ... ; ``` |  sets ```var``` whether all args are descending or not (ex:  6,3,1,0 --> true) |

## sml
one argument:
| lbpl | equivalent |
|--|--|
| ```big var num1;``` |  ```var = var < num1``` |

two arguments:

| lbpl | equivalent |
|--|--|
| ```big var num1 num2;``` |  ```var = num1 < num2``` |

multiple arguments:

| lbpl | equivalent |
|--|--|
| ```not var ... ; ``` |  sets ```var``` whether all args are ascending or not (ex:  0,1,3,6 --> true) |

## set

| lbpl | equivalent |
|--|--|
| ```set var num1;``` |  ```var = num1``` |

## goto

| lbpl | equivalent |
|--|--|
| ```goto coordinate``` |  the interpreter will go to the ":coordinate" indicator on the code and start running from there |

## ifgt

| lbpl | equivalent |
|--|--|
| ```ifgt var coordinate``` |  the interpreter will go to the ":coordinate" indicator on the code and start running from there *ONLY* if var is true |

## print

| lbpl | equivalent |
|--|--|
| ```print ...; ``` |  ```print(...)``` |
