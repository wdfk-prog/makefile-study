# makefile学习

[TOC]

- `.PHONY`
.PHONY 是一个特殊的目标，它告诉 make 这些目标不是实际的文件，而是伪目标。这样可以避免与同名文件冲突，并确保这些目标总是被执行。通常用于定义一些不会生成文件的命令，比如 clean、all 等。

# 运算符

## 1.`&`
- 用于引用变量

## 2.`$@`
- 是自动变量，代表目标文件的名称。

## 3. `$<`
- 也是一个自动变量，代表第一个依赖项3

```makefile
# 将SDIR路径下的所有.c文件进行生成.o文件
$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
#-c选项告诉编译器生成目标文件，-o $@选项指定输出文件的名称，$@是自动变量，代表目标文件的名称。$<也是一个自动变量，代表第一个依赖项，也就是对应的.c文件
	$(CC) -c -o $@ $< $(CFLAGS)
```

## 4.`@`
- 用于禁止输出命令;Makefile 会在执行命令之前打印出该命令。如果在命令前加上 @ 符号，Makefile 就不会打印该命令，只会执行它。

## 5.`%`
- `%` 是一个通配符，用于模式匹配。它可以匹配零个或多个字符，通常用于定义隐式规则和模式规则。

## 6.`?=`
-  是一种条件赋值运算符。它的作用是：如果变量尚未被赋值，则赋予等号右侧的值。如果变量已经有值，则保持原值不变。

# 内置变量

## 1. CC
- 指定编译器,例如:`CC = gcc`

## 2. SHELL
- 指定shell,例如:`SHELL = /bin/sh`;`SHELL	=	powershell.exe`

## 3. THREADS
- 指定线程数,例如:`THREADS = 4`

## 4. CFLAGS
- 指定编译选项,例如:`CFLAGS = -Wall -g`

### 4.1. -g
- 此选项会让编译器生成调试信息，使得你可以使用像gdb这样的调试工具进行调试。

### 4.2. -Wall
- 此选项会让编译器显示所有的警告信息。

### 4.3. -O
- 此选项会让编译器进行优化，提高程序的运行速度。
- O2：此选项告诉编译器进行优化，2 表示优化级别。级别越高，编译器进行优化的程度就越大，但也可能需要更长的编译时间。

### 4.4. -I
- 此选项用于指定头文件的搜索路径，例如:`CFLAGS = -I/usr/include`
- 这是一个编译器选项，.表示当前目录。编译器会在当前目录下查找头文件。

### 4.5. -L
- 此选项用于指定库文件的搜索路径，例如:`CFLAGS = -L/usr/lib`
- 这是一个链接器选项，.表示当前目录。链接器会在当前目录下查找库文件。

### 4.6. -fPIC
- 此选项用于生成位置无关的代码，例如:`CFLAGS = -fPIC`
- fPIC：此选项告诉编译器生成位置无关代码（Position Independent Code）。这种代码可以在内存的任何位置正确地执行，这对于动态链接库（如.so文件）是必需的。

### 4.7. -shared
- 此选项用于生成共享库，例如:`CFLAGS = -shared`
- 此选项告诉编译器生成一个共享对象，可以链接到其他对象中。这通常用于创建动态链接库。

### 4.8. -fcallgraph-info=su
- ：生成函数和变量的调用图信息。
- `-fcallgraph-info` 标志在 GCC（GNU 编译器集合）中用于生成调用图信息。此信息对于分析和代码的性能非常有用。调用图显示了函数之间的关系，特别是哪些函数调用了哪些其他函数。
- `=su` 部分指定调用图信息的格式。在本例中，`su` 代表“静态用法”，这意味着调用图将包含有关静态函数及其用法的信息。

### 4.9. -Wextra
- 启用 -Wall 中未包含的其他警告消息。

### 4.10. -pedantic
- 严格执行 ISO C 和 ISO C++ 合规性。

### 4.11. -Wmissing-prototypes
- 如果定义了全局函数而没有先前的原型声明，则发出警告。

### 4.12. -ftrack-macro-expansion=0
- 禁用对巨集扩展的跟踪
- 如果您想要减少生成的调试信息量，这可能很有用，因为跟踪巨集扩展有时会产生大量数据。禁用巨集扩展跟踪可以使调试过程更快，生成的调试信息更小，但可能会使跟踪与宏相关的问题变得更加困难。


# 内置函数

## 1. $(shell command)
- 执行shell命令,例如:`$(shell ls)`

### 1.1 输出git中最近的标签信息
```makefile
(shell git describe --tags --abbrev=0)
```

### 1.2 输出git中最近的提交信息
```makefile
(shell git rev-parse --short HEAD)
```

## 2. notdir
- 用于从路径中提取文件名

```makefile
$(notdir src/foo.c bar.c /home/user/baz.c)

#result: 
foo.c bar.c baz.c
```

## 3. wildcard
- $(wildcard pattern)

单个文件名可以使用通配符指定多个文件。make 中的通配符是 ' * '、' ? ' 和 ' […] '，与 Bourne shell 中的相同。例如， *.c 指定名称以 ' .c ' 结尾的所有文件（在工作目录中）的列表。
如果表达式与多个文件匹配，则将对结果进行排序。但是，多个表达式不会进行全局排序。例如， *.c *.h 将列出名称以 ' .c ' 结尾的所有文件，排序后，然后是名称以 ' .h ' 结尾的所有文件，排序。
文件名开头的字符“ ~ ”也具有特殊意义。如果单独使用，或后跟斜杠，则表示您的主目录。例如 ~/bin ，扩展为 /home/you/bin 。如果 ' ~ ' 后面跟着一个单词，则该字符串表示由该单词命名的用户的主目录。例如 ~john/bin ，扩展为 /home/john/bin 。在没有每个用户的主目录的系统（例如 MS-DOS 或 MS-Windows）上，可以通过设置环境变量 HOME 来模拟此功能。
通配符扩展是通过在目标和先决条件中自动执行的。在配方中，shell 负责通配符扩展。在其他上下文中，仅当您使用通配符函数显式请求通配符扩展时，才会发生通配符扩展。
通配符的特殊意义可以通过在通配符前面加上反斜杠来关闭。因此， foo\*bar 将引用名称由 ' foo '、星号和 ' bar ' 组成的特定文件。

```makefile
$(wildcard *.c)
```

## 4. patsubst
- 替换通配符

（patsubst pattern，replacement，text）
pattern 是要匹配的模式。
replacement 是要替换的字符串。
text 是要进行替换操作的文本。

```makefile
# patsubst 是一个模式替换函数，将 $(_DEPS) 中的每一个元素进行模式替换。在这里，% 是一个通配符，它匹配 $(_DEPS) 中的任何元素，$(IDIR)/% 表示将匹配到的元素替换为 $(IDIR)/元素。
# 将IDIR路径下的所有头文件进行替换
DEPS	=	$(patsubst %,$(IDIR)/%,$(_DEPS))
```

## 5. $(info ...)
- 打印信息
- 用于在执行 make 命令时打印信息。它不会影响构建过程，只是用于输出调试信息或其他有用的消息。

## 6. filter-out
- $(filter-out pattern…,text)
- 从 text 中删除与 pattern 匹配的单词。

```makefile
# filter-out 是一个 Makefile 函数，它从列表中移除匹配指定模式的元素。在这里，它从 $(temp) 列表中移除所有匹配 ../jni/deviceLibJNI.c 的元素。
src1 = $(filter-out ../jni/deviceLibJNI.c, $(temp))
```

## 7. addprefix
- $(addprefix prefix, names)

```makefile
# addprefix 是一个 Makefile 函数，它将指定的前缀添加到列表中的每个元素。在这里，它将 $(IDIR) 添加到 $(_DEPS) 列表中的每个元素。
# 将IDIR路径添加到_DEPS中的每个元素
DEPS	=	$(addprefix $(IDIR)/,$(_DEPS))
```
