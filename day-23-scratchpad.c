#include <stdio.h>

/*
 * This code is not the solution.
 * It's a scratchpad I used to decipher the assembly code and understand
 * the logic behind it.
 *
 * The solution was written in day-23.exs.
 *
 * main() and shortened() are equivalent, assuming a = 1
 */

int a = 1;
int b = 0;
int c = 0;
int d = 0;
int e = 0;
int f = 0;
int g = 0;
int h = 0;

int main() {
  b = 65; // 1                : set b 65
  c = b; // 2                 : set c b

  if(a) { // 3, 4             : jnz a 2; jnz 1 5
    b *= 100; // 5            : mul b 100
    b += 100000; // 6         : sub b -100000
    c = b; // 7               : set c b
    c += 17000; // 8          : sub c -17000
  }

  do {
    f = 1; // 9               : set f 1

    do {
      d = 2; // 10            : set d 2
      e = 2; // 11            : set e 2

      do {
        g = d; // 12          : set g d
        g *= e; // 13         : mul g e
        g -= b; // 14         : sub g b
        if(!g) { // 15        : jnz g 2
          f = 0; // 16        : set f 0
        }
        e += 1; // 17         : sub e -1
        g = e; // 18          : set g e
        g -= b; // 19         : sub g b
      } while(g); // 20

      d += 1; // 21           : sub d -1
      g = d; // 22            : set g d
      g -= b; // 23           : sub g b
    } while(g); // 24         : jnz g -13

    if(!f) { // 25            : jnz f 2
      h += 1; // 26           : sub h -1
    }

    g = b; // 27              : set g b
    g -= c; // 28             : sub g c
    if(!g) { // 29            : jnz g 2
      break; // 30            : jnz 1 3
    }

    b += 17; // 31            : sub b -17
  } while(1) // 32            : jnz 1 -23
  
  printf("%d", h);
  return 0;
}

int shortened() {
  for(int b = 106500; b <= 123500; b += 17) { // 1 - 8; 27 - 29; 31
    f = 1; // 9

    
    for(int d = 2; d < b; d++) { // 12; 22 - 24; 21
      for(int e = 2; e < b; e++) { // 13; 18 - 20; 17
        if(d * e == b) { // 12 - 15
          f = 0; // 16
        }
      }
    }

    if(!f) { // 25
      h += 1; // 26
    }
  }
  
  printf("%d", h);
  return 0;
}
