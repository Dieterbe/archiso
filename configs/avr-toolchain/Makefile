kver=2.6.32-ARCH
ver=$(shell date +%Y.%m)

WORKDIR=work

ARCH?=$(shell uname -m)
REPO_ARCH_AVR="file:///home/arch-avr/os/$(ARCH)"
PUBLISHER="Gerardo Exequiel Pozzi <http://www.github.com/djgera/archiso-avr>"
APPLICATION="Arch Linux Live Media with AVR toolchain and tools"
LABEL=AVR_$(ver)

ISOname=archlinux-$(ver)-avr-$(ARCH).iso

PACKAGES="$(shell cat packages.lst)"

all: default-iso

# Rules for each type of image
default-iso: $(ISOname)

$(ISOname): base-fs
	mkarchiso -P $(PUBLISHER) -A $(APPLICATION) -L $(LABEL) iso $(WORKDIR) $@

# This is the main rule for make the working filesystem.
base-fs: overlay root-image bootfiles initcpio iso-mounts


# Rules for make the root-image for base filesystem.
root-image: $(WORKDIR)/root-image/.arch-chroot
$(WORKDIR)/root-image/.arch-chroot:
	mkarchiso -p base create $(WORKDIR)
	mkarchiso -p base-devel create $(WORKDIR)
	mkarchiso -C $(WORKDIR)/overlay/etc/pacman.conf -p $(PACKAGES) create $(WORKDIR)
	./purge.sh


# Rule for make /boot
bootfiles: root-image
	mkdir -p $(WORKDIR)/iso/boot
	cp $(WORKDIR)/root-image/boot/System.map26 $(WORKDIR)/iso/boot/
	cp $(WORKDIR)/root-image/boot/vmlinuz26 $(WORKDIR)/iso/boot/
	cp -r boot-files/* $(WORKDIR)/iso/boot/
	cp $(WORKDIR)/root-image/usr/lib/syslinux/*.c32 $(WORKDIR)/iso/boot/isolinux/
	cp $(WORKDIR)/root-image/usr/lib/syslinux/isolinux.bin $(WORKDIR)/iso/boot/isolinux/
	cp $(WORKDIR)/root-image/usr/lib/syslinux/memdisk $(WORKDIR)/iso/boot/isolinux/


# Rules for initcpio images
initcpio: $(WORKDIR)/iso/boot/archiso.img
$(WORKDIR)/iso/boot/archiso.img: mkinitcpio.conf $(WORKDIR)/root-image/.arch-chroot
	mkdir -p $(WORKDIR)/iso/boot
	mkinitcpio -c ./mkinitcpio.conf -b $(WORKDIR)/root-image -k $(kver) -g $@


# overlay filesystem
overlay:
	mkdir -p $(WORKDIR)
	cp -r overlay $(WORKDIR)/
	echo "[arch-avr]" >> $(WORKDIR)/overlay/etc/pacman.conf
	echo "Server = $(REPO_ARCH_AVR)" >> $(WORKDIR)/overlay/etc/pacman.conf


# Rule to process isomounts file.
iso-mounts: $(WORKDIR)/isomounts
$(WORKDIR)/isomounts: isomounts root-image
	sed "s|@ARCH@|$(ARCH)|g" isomounts > $@


# Clean-up all work
clean:
	rm -rf $(WORKDIR) $(ISOname)


.PHONY: all default-iso
.PHONY: base-fs
.PHONY: root-image bootfiles initcpio overlay iso-mounts
.PHONY: clean
