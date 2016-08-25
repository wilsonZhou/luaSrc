--[[
-- function: 通过参数用户ID和时间，来获取当前用户朋友观看列表信息
-- date: 20160705
-- bug:
--]]
string.split = function(s, p)
    redis.log(redis.LOG_NOTICE,'split str:'..s);
    local rt= {};
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end );
    return rt;
end

redis.log(redis.LOG_NOTICE,'KEY1:'..KEYS[1]);
local uidList = string.split(KEYS[1],',');

redis.log(redis.LOG_NOTICE,'KEY2:'..KEYS[2]);
local curTime = KEYS[2];
local curDay = string.sub(curTime,1,8);
redis.log(redis.LOG_NOTICE,'curDay:'..curDay);
local curMin = string.sub(curTime,1,11)..'0';
redis.log(redis.LOG_NOTICE,'curMin:'..curMin);

for _,uid in ipairs(uidList) do
    redis.call('select',9);
    redis.call('del','vod_'..uid, 'watchtv_'..uid, 'live_'..uid, 'replay_'..uid);
    local userResult = {};
    redis.call('select',8);
    local friendIDs = redis.call('lrange',uid..'_friends_'..curMin, 0, -1);
    for _,friID in ipairs(friendIDs) do
        redis.call('select',8);
        local userInfo = redis.call('hget','user_list_'..curDay,friID);
        local friName = friID;
        if userInfo~=nil and type(userInfo)=='string' then
            friName = string.split(userInfo,'#')[1];
            redis.log(redis.LOG_NOTICE,'userInfo:'..userInfo);
        else
            friName  = friID
        end
        redis.call('select',9);
        local friWatchKeys = redis.call('keys', friID..'_*');
        for _,friWatchKey in ipairs(friWatchKeys) do
            local watchRec = redis.call('get',friWatchKey);
            if watchRec~=nil and type(watchRec)=='string' then
                local friWatchKeyItem = string.split(friWatchKey,'_');
                redis.log(redis.LOG_NOTICE,'friWatchKey:'..friWatchKey);
                local friWatchValItem = string.split(watchRec,'#');
                redis.log(redis.LOG_NOTICE,'watchRec:'..watchRec);
                local k = friWatchKeyItem[2]..'_'..uid;
                local f = friWatchKeyItem[3]..'_'..friWatchValItem[3]..'_'..friWatchValItem[4]..'_'..friWatchValItem[5];
                local v = friID..'|'..friName;
                if(nil~=userResult[k..'_'..f]) then
                    userResult[k..'_'..f]=userResult[k..'_'..f]..'@@'..v;
                else
                    userResult[k..'_'..f] = v;
                end
            end
        end
    end
    redis.call('select', 9);
    for k,v in pairs(userResult) do
        local kItem = string.split(k,'_');
        redis.log(redis.LOG_NOTICE,'k:'..k);
        local key = kItem[1]..'_'..kItem[2];
        
        local vItem = string.split(v,'@@');
        local friIDs = nil;
        local friNames = nil;
        for fi,fv in ipairs(vItem) do
            print(fi,fv);
            local  friend = string.split(fv,'|');
            if friIDs==nil then
                friIDs = friend[1];
                if table.getn(friend)==2 then
                    friNames = friend[2];
                end;
            else
                friIDs = friIDs..'#'..friend[1];
                if table.getn(friend)==2 then
                    friNames = friNames..'#'..friend[2];
                end;
            end;
        end;
        redis.log(redis.LOG_NOTICE,'v:'..v);
        local fri_cnt = table.getn(vItem);
        local member = friIDs..'|'..friNames..'_'..kItem[3]..'_'..kItem[4]..'_'..kItem[5]..'_'..kItem[6];
        redis.call('zadd',key,fri_cnt,member);
        redis.call('expire',key,300);
    end
end
return 1;
