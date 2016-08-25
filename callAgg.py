#!/usr/bin/env python
# -*- coding:utf-8 -*-

import time
from datetime import datetime  
from datetime import timedelta
import os

def main():
    curTime = time.strftime("%Y%m%d%H%M", time.localtime());
    print curTime;
    m = int(curTime[11:12]);
    print m;
    mi = 10
    if m <=4:
        mi = 5
    ml = mi - m
    print ml
    atime = timedelta(minutes=ml)
    now = datetime.strptime(curTime, "%Y%m%d%H%M");
    print now+atime
    # print type(now+atime)
    dt = datetime.strftime(now+atime, "%Y%m%d%H%M")
    print dt
    print os.popen('/data/server/redis/bin/redis-cli --eval /home/yanfa/zhouwch/aggCityHis.lua '+dt).readline();
    print "#############################################################"
    #print os.popen('/data/server/redis/bin/redis-cli --eval /home/yanfa/zhouwch/1.lua 201607062005').readline();

if __name__ == '__main__':
    main()
