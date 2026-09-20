#Makefile
obj-m   := vtzdriver.o

vtzdriver-objs := vtzf.o

RESULT := $(shell cat /proc/kallsyms | grep vsnprintf_s)

STATUS := $(findstring vsnprintf_s, $(RESULT))

# ifneq ($(STATUS), vsnprintf_s)
vtzdriver-objs += libboundscheck/src/memcpy_s.o libboundscheck/src/memset_s.o libboundscheck/src/strcpy_s.o libboundscheck/src/strncpy_s.o \
libboundscheck/src/memmove_s.o libboundscheck/src/strcat_s.o libboundscheck/src/strncat_s.o libboundscheck/src/strtok_s.o \
libboundscheck/src/securecutil.o libboundscheck/src/secureprintoutput_a.o libboundscheck/src/snprintf_s.o libboundscheck/src/vsnprintf_s.o
# endif
vtzdriver-objs += tlogger.o serialport.o tee_info.o reserved_shm.o process_data.o block_pages.o reg_mem_ht.o

KPATH := /usr/src/kernels
KDIR  := $(KPATH)/$(shell ls $(KPATH))

EXTRA_CFLAGS += -fstack-protector-strong -DCONFIG_AUTH_ENHANCE
EXTRA_CFLAGS += -I$(PWD)/libboundscheck/include/  -I$(PWD)
EXTRA_CFLAGS += -I$(PWD)/inc/

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	-rm -vrf *.o *.ko
	-rm -vrf *.order *.symvers *.mod.c *.mod.o .tmp_versions .*o.cmd .*.o.d *.mod .*.cmd