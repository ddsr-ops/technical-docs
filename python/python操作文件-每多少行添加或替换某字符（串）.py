#!/usr/bin/env python
# -*- coding:utf-8 -*-
# python2必须要写coding，python默认使用utf-8，可以不用加
# Author: Changhua Gong

def update_file(file_path: str, str_to_add: str, num_line_to_break: int, add_tail_line: bool = True):
    """
    Add the same str_to_add as the line interpolated into the file every number of num_line_to_break.

    If the new file exists, it would be truncated before writing.

    :param file_path: file path, supporting absolute path or relative path
    :param str_to_add: content to add
    :param num_line_to_break: every number, interpolate the str_to_add content
    :param add_tail_line: add the str_to_add to the end of new file if True, or nothing
    :return:
    """
    with open(file_path, "r") as f:
        with open(file_path + ".new", "w+") as file_new:
            n = 0
            for line in f:
                n += 1
                if n % num_line_to_break == 0:
                    line = line.replace("\n", f"\n{str_to_add}\n")
                file_new.write(line)
            if add_tail_line:
                file_new.write("\n" + str_to_add)
            file_new.flush()


update_file(r"text.md", "commit;", 3)
