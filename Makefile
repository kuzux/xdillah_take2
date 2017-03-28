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
LIBS:=$(LIBS) -nostdlib -lk -lgcc

ARCHDIR:=arch/x86_64

include $(ARCHDIR)/make.config
 
CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

OBJS:=\
$(KERNEL_ARCH_OBJS) \

all: dummy.txt

install: install-headers install-kernel
 
install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -Rv include/ $(DESTDIR)$(INCLUDEDIR)

dummy.txt: 
	echo "Dummy"

install-kernel: dummy.txt
