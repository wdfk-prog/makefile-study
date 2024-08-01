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
src1 = $(filter-out ../jni/deviceLibJNI.c, $(temp))
obj  = $(patsubst %.c, obj/%.o, $(notdir $(src)))
obj1 = $(patsubst %.c, obj/%.o, $(notdir $(src1)))
OBJ_PATH = ./obj
ASM_PATH = ./asm
#obj=$(dir:%.c=%.o)

$(shell if [ ! -d obj ]; then mkdir obj; fi)
$(shell if [ ! -d asm ]; then mkdir asm; fi)

$(TARGET):$(obj) $(obj1)
	$(CC) -o $(TARGET) $^ $(LIBS) $(LINKS) 

$(obj):$(OBJ_PATH)/%.o:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(OBJ_PATH)/$*.o -c $*.c

$(obj1):$(OBJ_PATH)/%.o:../jni/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(OBJ_PATH)/$*.o -c ../jni/$*.c

.PHONY: asm
asm: $(src) $(src1)
	@for file in $^; do \
		$(CC) $(CFLAGS) $(INCLUDES) -S $$file -o $(ASM_PATH)/$$(basename $$file).s; \
	done

compile:$(TARGET)

install: $(TARGET)
	cp $(TARGET) $(INSTALL_PATH)

uninstall:
	rm -f $(INSTALL_PATH)/$(TARGET)

rebuild: clean compile

clean:
	rm -rf $(OBJ_PATH)/* $(ASM_PATH)/* $(TARGET) *.log *~
