#!/bin/bash

#Define Vendor IDs (VID)
VENDOR_ID=0374
VENDOR_NAME="GWEF"
DEVICE_ID=0001
DEVICE_NAME="AMD Antenna Controller"

#Define System Level Directories
PCI_VIDS=/usr/share/hwdata/pci.ids
ALT_DIR=/usr/local/share/hwdata
ALT_VIDS=$ALT_DIR/pci.ids
ENV_FILE=/etc/profile.d/pci_ids.sh

#Check if file exists
if grep -q "^$VENDOR_ID" $PCI_VIDS; then
	echo "$VENDOR_NAME $VENDOR_ID alreay exists"
	exit 0
fi

#Copy from original vid list
mkdir --parents $ALT_DIR
cp $PCI_VIDS $ALT_VIDS

#Write new device information to vid file
echo -en "\n\n" 			>> $ALT_VIDS
echo -en "# $VENDOR_NAME CUSTOM VIDs" 	>> $ALT_VIDS
echo -en "\n\n" 			>> $ALT_VIDS
echo -en "$VENDOR_ID  $VENDOR_NAME\n" 	>> $ALT_VIDS
echo -en "\t$DEVICE_ID $DEVICE_NAME\n" 	>> $ALT_VIDS
echo -en "\n\n" 			>> $ALT_VIDS

#Environment settings
echo -en "#!/bin/bash\n\n"		    > $ENV_FILE
echo -en "export PCI_IDS_PATH=$ALT_VIDS\n" >> $ENV_FILE
echo -en "alias lspci='lspci -i $ALT_VIDS'\n" >> $ENV_FILE
