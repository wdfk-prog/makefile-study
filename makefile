# 输出git中最近的标签信息
VERSION	= $(shell git describe --tags --abbrev=0)
# 指定编译器
CC		=	gcc
# 指定控制台
# SHELL	=	powershell.exe
# 指定编写线程数量
THREADS = 	12
# -I.：这是一个编译器选项，.表示当前目录。编译器会在当前目录下查找头文件。
IDIR	=	-Iinclude
# -g：此选项会让编译器生成调试信息，使得你可以使用像gdb这样的调试工具进行调试。
# -O2：此选项告诉编译器进行优化，2 表示优化级别。级别越高，编译器进行优化的程度就越大，但也可能需要更长的编译时间。
CFLAGS	=	-I$(IDIR) -g -O2
# 
LIBS	= 
# 
LINKS	= 
# 
_DEPS	=	$(notdir $(wildcard $(IDIR)/*.h))
# patsubst 是一个模式替换函数，将 $(_DEPS) 中的每一个元素进行模式替换。在这里，% 是一个通配符，它匹配 $(_DEPS) 中的任何元素，$(IDIR)/% 表示将匹配到的元素替换为 $(IDIR)/元素。
# 将IDIR路径下的所有头文件进行替换
DEPS	=	$(patsubst %,$(IDIR)/%,$(_DEPS))
# 指定源文件目录
SDIR    =   ./src
# 指定目标文件目录及其替换字符串
ODIR	=	obj
# $(patsubst %.c,%.o, ...) 会将 .c 文件名替换为 .o 文件名
_OBJ	=	$(patsubst %.c,%.o,$(notdir $(wildcard $(SDIR)/*.c)))
OBJ		=	$(patsubst %,$(ODIR)/%,$(_OBJ))

# 使用 rm -rf 命令删除 release/$(VERSION) 目录及其下的所有文件和子目录。如果该目录不存在，rm -rf 命令不会报错。
$(shell rm -rf release/$(VERSION))
# 使用 mkdir -p 命令创建 $(BUILD_DIR) 目录。如果该目录已经存在，mkdir -p 命令不会报错。
$(shell mkdir -p $(ODIR))
# 使用 mkdir -p 命令创建 release/$(VERSION) 目录。如果该目录已经存在，mkdir -p 命令不会报错。
$(shell mkdir -p release/$(VERSION))
# 这行代码将 #define PRE_CONFIG_LIB_VERSION    "$(VERSION)" 写入 libversion.h 文件。如果该文件已经存在，这行代码会覆盖原有内容。
$(shell echo "#define PRE_CONFIG_LIB_VERSION    \"$(VERSION)\"" > libversion.h)
# if [ ! -d obj ]; then mkdir obj; fi：这是一个 shell 命令，它首先检查 obj 目录是否存在（[ ! -d obj ]），如果不存在，则创建 obj 目录（mkdir obj）。
$(shell if [ ! -d obj ]; then mkdir obj; fi)

# 隐式规则 自动构建
# %是一个通配符，它在目标和依赖项中都会被同样的字符串替换。
# 将SDIR路径下的所有.c文件进行生成.o文件
$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
#-c选项告诉编译器生成目标文件，-o $@选项指定输出文件的名称，$@是自动变量，代表目标文件的名称。$<也是一个自动变量，代表第一个依赖项，也就是对应的.c文件
	$(CC) -c -o $@ $< $(CFLAGS)

# 链接
test: $(OBJ)
	$(info $(VERSION))
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

compile: $(TARGET) $(TEST_TARGET)
# ：将字符串 "version : " 追加到 $(INFOFILE) 文件中。\c 表示不换行。
	@echo -e "version   : \c" >> $(INFOFILE)
	@echo -e $(VERSION)       >> $(INFOFILE)
	@echo -e "build time: \c" >> $(INFOFILE)
# 将当前日期和时间追加到 $(INFOFILE) 文件中。
	@date >> $(INFOFILE)
	@echo -e "md5       : \c" >> $(INFOFILE)
# 计算 $(TARGET) 文件的 MD5 校验和，并将结果追加到 $(INFOFILE) 文件中。
	@md5sum $(TARGET) >> $(INFOFILE)
	@echo -e "change log:" >> $(INFOFILE) 
# 获取 git 提交日志，并将其以特定的格式追加到 $(INFOFILE) 文件中。这里的格式是：提交日期和提交信息。
	@git log --pretty=format:'%cd    %s' --abbrev-commit >> $(INFOFILE)

.PHONY: clean

clean:
	rm -rf $(BUILD_DIR) release/$(VERSION) *.o *.dll *.so *.exe *.gitinfo *.log *~

print:
	$(info $(_DEPS))