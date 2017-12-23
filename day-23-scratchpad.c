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
  b = 65; // 1
  c = b; // 2

  if(a) { // 3, 4
    b *= 100; // 5
    b += 100000; // 6
    c = b; // 7
    c += 17000; // 8
  }

  while(1) {// 32
    f = 1; // 9

    do {
      d = 2; // 10
      e = 2; // 11

      do {
        g = d; // 12
        g *= e; // 13
        g -= b; // 14
        if(!g) { // 15
          f = 0; // 16
        }
        e += 1; // 17
        g = e; // 18
        g -= b; // 19
      } while(g); // 20

      d += 1; // 21
      g = d; // 22
      g -= b; // 23
    } while(g); // 24

    if(!f) { // 25
      h += 1; // 26
    }

    g = b; // 27
    g -= c; // 28
    if(!g) { // 29
      break; // 30
    }

    b += 17; // 31
  }
  
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
