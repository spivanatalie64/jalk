/* SPDX-License-Identifier: GPL-2.0-only */
#ifndef _LINUX_JALK_H
#define _LINUX_JALK_H

#ifdef CONFIG_JALK
extern const char jalk_version_string[];
#else
#define jalk_version_string "vanilla"
#endif

#endif /* _LINUX_JALK_H */
