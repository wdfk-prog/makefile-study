# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#   2023-09-16 - first version
# ------------------------------------------------

CC              = gcc
# 输出git中最近的标签信息
VERSION         = $(shell git describe --tags --abbrev=0)
TARGET          = release/$(VERSION)/pre_config.dll
INFOFILE        = release/$(VERSION)/pre_config.gitinfo
TEST_TARGET     = pre_config_test
# -g：此选项会让编译器生成调试信息，使得你可以使用像gdb这样的调试工具进行调试。
# -O2：此选项告诉编译器进行优化，2 表示优化级别。级别越高，编译器进行优化的程度就越大，但也可能需要更长的编译时间。
# -fPIC：此选项告诉编译器生成位置无关代码（Position Independent Code）。这种代码可以在内存的任何位置正确地执行，这对于动态链接库（如.so文件）是必需的。
# -shared：此选项告诉编译器生成一个共享对象，可以链接到其他对象中。这通常用于创建动态链接库。
CFLAGS          = -g -O2 -fPIC -shared
LIBS            = 
LINKS           = 
# -I.：这是一个编译器选项，.表示当前目录。编译器会在当前目录下查找头文件。
INCS            = -I. -Icore -Idevice
SRCS            = $(wildcard core/*.c device/*.c)

BUILD_DIR = obj
# $(SRCS:.c=.o)：将 SRCS 列表中所有 .c 文件的扩展名替换为 .o。
# $(addprefix $(BUILD_DIR)/, ...)：在每个文件名前面添加前缀 $(BUILD_DIR)/，即 obj/。
# vpath %.c $(sort $(dir $(SRCS)))：这行代码定义了一个 vpath（虚拟路径），用于在多个目录中搜索 .c 文件。
# $(dir $(SRCS))：获取 SRCS 列表中每个文件的目录名。
# $(sort ...)：对目录名进行排序，并移除重复项。
# vpath %.c ...：对所有 .c 文件设置虚拟路径，当 make 需要找 .c 文件时，会在这些目录中搜索。
OBJS = $(addprefix $(BUILD_DIR)/,$(notdir $(SRCS:.c=.o)))
vpath %.c $(sort $(dir $(SRCS)))

# 使用 rm -rf 命令删除 release/$(VERSION) 目录及其下的所有文件和子目录。如果该目录不存在，rm -rf 命令不会报错。
$(shell rm -rf release/$(VERSION))
# 使用 mkdir -p 命令创建 $(BUILD_DIR) 目录。如果该目录已经存在，mkdir -p 命令不会报错。
$(shell mkdir -p $(BUILD_DIR))
# 使用 mkdir -p 命令创建 release/$(VERSION) 目录。如果该目录已经存在，mkdir -p 命令不会报错。
$(shell mkdir -p release/$(VERSION))
# 这行代码将 #define PRE_CONFIG_LIB_VERSION    "$(VERSION)" 写入 libversion.h 文件。如果该文件已经存在，这行代码会覆盖原有内容。
$(shell echo "#define PRE_CONFIG_LIB_VERSION    \"$(VERSION)\"" > libversion.h)

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

$(OBJS): $(BUILD_DIR)/%.o:%.c
	$(CC) $(INCS) -o $@ -c $<

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) $(LINKS) $(INCS) -o $@ pre_config_api.c $^

$(TEST_TARGET): $(OBJS)
	$(CC) $(LIBS) $(LINKS) $(INCS) -o $@ pre_config_test.c pre_config_api.c $^

rebuild: clean compile

clean:
	rm -rf $(BUILD_DIR) release/$(VERSION) *.o *.dll *.so *.exe *.gitinfo *.log *~
