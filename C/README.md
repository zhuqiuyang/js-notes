### Gcc 常用

```sh
gcc
# -c: 生成目标文件
# -I[dir]: index头文件
# -l[library]: search library 在link 阶段
# -L[dir]: Link库
# -o: 输出
# -W[all]: 输出warn信息(all)
```

### 制作 static library

> ./static_lib;

```sh
gcc -Wall -c hello_fn.c && gcc -Wall -c bye_fn.c

# ar : 把多个 files combined into an archive.
# c: crate, r: replace, s: write the index
ar crs libhello.a hello_fn.o bye_fn.o

# t 表示: content, 显示包内容.
ar t libhello.a

gcc -Wall main.c libhello.a -o hello

# Link
gcc -Wall -L. main.c -lhello -o hello
```

- Link external Lib

```sh
# 两者等同
gcc -Wall calc.c /usr/lib/libm.a -o calc
gcc -Wall calc.c -lm -o calc
```

> `-lNAME` 尝试 link object files with a library file `libNAME.a` in the standard library directories

### The C Programming Language