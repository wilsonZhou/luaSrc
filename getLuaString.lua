#!/usr/bin/env python
# -*- coding:utf-8 -*-



def main():
    lines = ''
    # f = open('/Users/zhouwenchun/Documents/SRC/pySrc/spider/computeFriWatchHis.lua','r')
    f = open('/Users/zhouwenchun/Documents/SRC/pySrc/spider/getFri.lua','r')
    for line in f.readlines():
        if not line.startswith('--'):
            lines = lines+' '+line.strip('\n')
    f.close()
    print(lines)

if __name__ == '__main__':
    main()
