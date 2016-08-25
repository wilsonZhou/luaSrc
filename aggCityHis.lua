--[[
-- function: 遍历所有用户观看信息，统计同城热播节目列表信息;
-- date: 2016-07-06 20:27
-- author: wilson
-- bugs:
--]]

string.split = function(s, p)
    local rt= {};
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end );
    return rt;
end

local curTime = KEYS[1];
redis.log(redis.LOG_NOTICE,'TIME:'..curTime);
local curDay = string.sub(curTime,1,8)

redis.call('select',9)
local  allKey = redis.call('keys', '*')
for _, k in ipairs(allKey) do
    redis.log(redis.LOG_NOTICE,'key:'..k);
    local kItems = string.split(k,'_')
    if table.getn(kItems)==3 then
        redis.log(redis.LOG_NOTICE,'invalidate kye:'..k);
        local val = redis.call('get',k);
        if val~= nil then
            redis.log(redis.LOG_NOTICE,'kye:'..k..' val:'..val);
            local  uid = kItems[1];
            local  bizType = kItems[2];
            local  psId = kItems[3];

            redis.call('select',8);
            local userInfo = redis.call('hget','user_list_'..curDay, uid);
            local area = '0000';
            if type(userInfo)~='string' and userInfo ~= nil then
                local userItem = string.split(userInfo,'#');
                local deviceId = userItem[2];
                redis.log(redis.LOG_NOTICE,'deviceId:'..deviceId)
                if deviceId~='NULL' then
                    local userCity = redis.call('hget','user_city_'..curDay, deviceId);
                    if type(userCity)=='string' and userCity~=nil then
                        area = userCity;
                    end;
                end;
            end;
            redis.log(redis.LOG_NOTICE,'area:'..area);

            local valItem = string.split(val,'#')
            local member = psId..'_'..bizType..'_'..valItem[3]..'_'..valItem[4]..'_'..valItem[5];

        end;
    end;
end;

return 1;
