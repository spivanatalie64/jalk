// SPDX-License-Identifier: GPL-2.0-only
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/sysfs.h>
#include <linux/kobject.h>
#include <linux/version.h>
#include <generated/utsrelease.h>

static struct kobject *jalk_kobj;

static ssize_t version_show(struct kobject *kobj,
			    struct kobj_attribute *attr, char *buf)
{
	return sysfs_emit(buf, "JALK " UTS_RELEASE "\n");
}

static struct kobj_attribute version_attribute =
	__ATTR_RO(version);

static ssize_t features_show(struct kobject *kobj,
			     struct kobj_attribute *attr, char *buf)
{
	return sysfs_emit(buf,
		"preempt\n"
		"hz_1000\n"
		"bbr_tcp\n"
		"multi_arch\n");
}

static struct kobj_attribute features_attribute =
	__ATTR_RO(features);

static int __init jalk_init(void)
{
	int ret;

	jalk_kobj = kobject_create_and_add("jalk", kernel_kobj);
	if (!jalk_kobj)
		return -ENOMEM;

	ret = sysfs_create_file(jalk_kobj, &version_attribute.attr);
	if (ret)
		goto err;

	ret = sysfs_create_file(jalk_kobj, &features_attribute.attr);
	if (ret)
		goto err_version;

	pr_info("JALK: Just Another Linux Kernel " UTS_RELEASE " loaded\n");

	return 0;

err_version:
	sysfs_remove_file(jalk_kobj, &version_attribute.attr);
err:
	kobject_put(jalk_kobj);
	return ret;
}

static void __exit jalk_exit(void)
{
	sysfs_remove_file(jalk_kobj, &features_attribute.attr);
	sysfs_remove_file(jalk_kobj, &version_attribute.attr);
	kobject_put(jalk_kobj);
}

module_init(jalk_init);
module_exit(jalk_exit);

MODULE_VERSION(UTS_RELEASE);
MODULE_DESCRIPTION("JALK - Just Another Linux Kernel");
MODULE_AUTHOR("Natalie <spivanatalie64>");
MODULE_LICENSE("GPL");
