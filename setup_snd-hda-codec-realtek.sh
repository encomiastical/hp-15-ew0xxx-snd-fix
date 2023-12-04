#!/bin/sh

# see https://www.collabora.com/news-and-blog/blog/2021/05/05/quick-hack-patching-kernel-module-using-dkms/

# make the script stop on error
set -e

KERNEL_MODULE_NAME='snd-hda-codec-realtek'
DKMS_MODULE_VERSION='0.1'

./dkms-module_prepare.sh

# set up the actual DKMS module -------------------------------------------------------------------

./dkms-module_create.sh "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"

# create the patch file to apply to the source of the snd-hda-codec-realtek kernel module
sudo tee "/usr/src/${KERNEL_MODULE_NAME}-${DKMS_MODULE_VERSION}/patch_realtek.patch" <<'EOF'
--- sound/pci/hda/patch_realtek.c
+++ sound/pci/hda/patch_realtek.c
@@ -9773,6 +9773,7 @@
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+    SND_PCI_QUIRK(0x103c, 0x8a31, "HP ENVY x360 2-in-1 Laptop 15-ey0xxx", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),

EOF

clear

./dkms-module_build.sh "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"
