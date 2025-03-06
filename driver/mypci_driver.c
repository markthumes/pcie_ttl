#include <linux/init.h>
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/delay.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/io.h>

#define DEVNO 64
#define DEVNONAME "mypci_dev"

#define VID 0x0374
#define DID 0x0001

//meta information
MODULE_LICENSE("GPL");

struct mypci_dev {
	struct pci_dev *pdev;
}mydev;

static int echo_mmap(struct file* file, struct vm_area_struct *vma){
	int status;

	vma->vm_pgoff = pci_resource_start(mydev.pdev, 1) >> PAGE_SHIFT;

	status = io_remap_pfn_range(
		vma, 
		vma->vm_start, 
		vma->vm_pgoff, 
		vma->vm_end - vma->vm_start,
		vma->vm_page_prot);
	if(status){
		printk("Error allocating device number\n");
		return -status;
	}
	return 0;
}

static struct file_operations fops = {
	.mmap = echo_mmap
};

static struct pci_device_id mypci_ids[] = {
    {PCI_DEVICE(VID, DID)},
    {},
};
MODULE_DEVICE_TABLE(pci, mypci_ids);

static int mypci_probe(struct pci_dev *pdev, const struct pci_device_id *id){
	int status;
	void __iomem *ptr_bar0;

	mydev.pdev = pdev;

	//allocate device number with device name and file operations
	status = register_chrdev(DEVNO, DEVNONAME, &fops);
	if( status < 0 ){
		printk("Error allocating device number\n");
		goto fdev;
	}

	status = pcim_enable_device(pdev);
	if( status != 0 ){
		printk("Error enabling device\n");
		goto fdev;
	}

	ptr_bar0 = pcim_iomap(pdev, 0, pci_resource_len(pdev, 0));
	if( !ptr_bar0 ){
		printk("Error mapping BAR0\n");
		status = -ENODEV;
		goto fdev;
	}

	printk("ID: 0x%x\n", ioread32(ptr_bar0));
	printk("Random Value: 0x%x\n", ioread32(ptr_bar0 + 0xc));
	
//	iowrite32(0x11223344, ptr_bar0+4);
	mdelay(1);
	printk("Inverse Pattern: 0x%x\n", ioread32(ptr_bar0 + 4));
	printk("BAR0 Offset 0: 0x%x\n", ioread8(ptr_bar0));
	printk("BAR0 Offset 0: 0x%x\n", ioread16(ptr_bar0));
	printk("BAR0 Offset 0: 0x%x\n", ioread32(ptr_bar0));

	return 0;

fdev:
	unregister_chrdev(DEVNO, DEVNONAME);
	return status;

	
}

static void mypci_remove(struct pci_dev *pdev){
	printk("Removing the device\n");
	unregister_chrdev(DEVNO, DEVNONAME);
}


static struct pci_driver mypci_driver = {
	.name = "mypci_driver",
	.id_table = mypci_ids,
	.probe = mypci_probe,
	.remove = mypci_remove,
};

module_pci_driver(mypci_driver);
