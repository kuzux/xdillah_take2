CFLAGS?=-O2 -ggdb
CPPFLAGS?=
LDFLAGS?=
LIBS?=
 
DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
BOOTDIR?=$(EXEC_PREFIX)/boot
INCLUDEDIR?=$(PREFIX)/include

XDILLAH_VERSION?=
XDILLAH_COMPILE_DATE?=
XDILLAH_COMPILE_ENV?=
XDILLAH_AUTHOR?=

CFLAGS:=$(CFLAGS) -ffreestanding -fbuiltin -Wall -Wextra 

CFLAGS:=$(CFLAGS) -D__is_xdillah_kernel -DXDILLAH_VERSION=\""$(XDILLAH_VERSION)"\" \
	-DXDILLAH_COMPILE_DATE=\"$(XDILLAH_COMPILE_DATE)\" -DXDILLAH_COMPILE_ENV=\""$(XDILLAH_COMPILE_ENV)"\" \
	-DXDILLAH_AUTHOR=\"$(XDILLAH_AUTHOR)\" -Iinclude -I../libc/include
CPPFLAGS:=$(CPPFLAGS)
LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib

ARCHDIR:=arch/x86_64

include $(ARCHDIR)/make.config
 
CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

OBJS:=\
$(KERNEL_ARCH_OBJS) \

all: build/kernel

install: install-headers install-kernel
 
install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -Rv include/ $(DESTDIR)$(INCLUDEDIR)

build/arch/%.o: $(ARCHDIR)/%.asm
	mkdir -p build/arch
	$(NASM) -f elf64 $< -o $@

build/kernel: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -n -o $@ $(CFLAGS) $(LDFLAGS) $(OBJS) $(LIBS)

install-kernel: build/kernel
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp build/kernel $(DESTDIR)$(BOOTDIR)
