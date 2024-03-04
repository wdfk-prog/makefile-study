CC       = gcc
WORKDIR  = 
INCLUDES = -I../jni/
LIBS     = 
LINKS    = 
TARGET   = nfc_test

CFLAGS += -g -O2
#-fshort-enums
src  = $(wildcard *.c)
temp = $(wildcard ../jni/*.c)
# filter-out 是一个 Makefile 函数，它从列表中移除匹配指定模式的元素。在这里，它从 $(temp) 列表中移除所有匹配 ../jni/deviceLibJNI.c 的元素。
src1 = $(filter-out ../jni/deviceLibJNI.c, $(temp))
obj  = $(patsubst %.c, obj/%.o, $(notdir $(src)))
obj1 = $(patsubst %.c, obj/%.o, $(notdir $(src1)))
OBJ_PATH = ./obj
#obj=$(dir:%.c=%.o)

# if [ ! -d obj ]; then mkdir obj; fi：这是一个 shell 命令，它首先检查 obj 目录是否存在（[ ! -d obj ]），如果不存在，则创建 obj 目录（mkdir obj）。
$(shell if [ ! -d obj ]; then mkdir obj; fi)

$(TARGET):$(obj) $(obj1)
	$(CC) -o $(TARGET) $^ $(LIBS) $(LINKS) 

$(obj):$(OBJ_PATH)/%.o:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(OBJ_PATH)/$*.o -c $*.c

$(obj1):$(OBJ_PATH)/%.o:../jni/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(OBJ_PATH)/$*.o -c ../jni/$*.c


compile:$(TARGET)

install: $(TARGET)
	cp $(TARGET) $(INSTALL_PATH)

uninstall:
	rm -f $(INSTALL_PATH)/$(TARGET)

rebuild: clean compile

clean:
	rm -rf $(OBJ_PATH)/* $(TARGET) *.log *~
