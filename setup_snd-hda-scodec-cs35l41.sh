#!/bin/sh

# see https://www.collabora.com/news-and-blog/blog/2021/05/05/quick-hack-patching-kernel-module-using-dkms/

# make the script stop on error
set -e

KERNEL_MODULE_NAME='snd-hda-scodec-cs35l41'
DKMS_MODULE_VERSION='0.1'

./dkms-module_prepare.sh

# set up the actual DKMS module -------------------------------------------------------------------

./dkms-module_create.sh "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"

# create the patch file to apply to the source of the snd-hda-scodec-cs35l41 kernel module
sudo tee "/usr/src/${KERNEL_MODULE_NAME}-${DKMS_MODULE_VERSION}/cs35l41_hda.patch" <<'EOF'
*** cs35l41_hda_property.c	2023-12-04 18:17:02.482381486 +0100
--- cs35l41_hda_property_patch.c	2023-12-04 18:23:02.208476883 +0100
***************
*** 34,40 ****
  
  	if (strcmp(hid, "CLSA0100") == 0) {
  		hw_cfg->bst_type = CS35L41_EXT_BOOST_NO_VSPK_SWITCH;
! 	} else if (strcmp(hid, "CLSA0101") == 0) {
  		hw_cfg->bst_type = CS35L41_EXT_BOOST;
  		hw_cfg->gpio1.func = CS35l41_VSPK_SWITCH;
  		hw_cfg->gpio1.valid = true;
--- 34,40 ----
  
  	if (strcmp(hid, "CLSA0100") == 0) {
  		hw_cfg->bst_type = CS35L41_EXT_BOOST_NO_VSPK_SWITCH;
! 	} else if (strcmp(hid, "CLSA0101") == 0 || strcmp(hid, "CSC3551") == 0) {
  		hw_cfg->bst_type = CS35L41_EXT_BOOST;
  		hw_cfg->gpio1.func = CS35l41_VSPK_SWITCH;
  		hw_cfg->gpio1.valid = true;
***************
*** 91,97 ****
  static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
  	{ "CLSA0100", NULL, lenovo_legion_no_acpi },
  	{ "CLSA0101", NULL, lenovo_legion_no_acpi },
! 	{ "CSC3551", "103C89C6", hp_vision_acpi_fix },
  	{}
  };
  
--- 91,98 ----
  static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
  	{ "CLSA0100", NULL, lenovo_legion_no_acpi },
  	{ "CLSA0101", NULL, lenovo_legion_no_acpi },
! 	{ "CSC3551", NULL, lenovo_legion_no_acpi },
! 	{ "CSC3551", "103C89C6", lenovo_legion_no_acpi },
  	{}
  };

EOF

clear

./dkms-module_build.sh "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"
