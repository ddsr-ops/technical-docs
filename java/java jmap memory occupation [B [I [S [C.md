```
jmap -histo 24527 | head -30
 num     #instances         #bytes  class name
----------------------------------------------
   1:         31939       98883072  [C
   2:          8594        9461992  [B
   3:         30326        4256232  <constMethodKlass>
```

* [C is a char[]
* [S is a short[]
* [I is a int[]
* [B is a byte[]
* [[I is a int[][]