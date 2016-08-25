redis.log(redis.LOG_NOTICE,'scan test');
redis.call('select', 9);
local dbsize = redis.call('dbsize');
redis.log(redis.LOG_NOTICE,dbsize);

if dbsize>0 then
local allkeys = redis.call('scan',0,'count',dbsize, 'match','*_*_*');
redis.log(redis.LOG_NOTICE,type(allkeys));
redis.log(redis.LOG_NOTICE,allkeys);
for k,v in pairs(allkeys[2]) do
  print(v)
end
--redis.log(redis.LOG_NOTICE,table.getn(allkeys));
--redis.log(redis.LOG_NOTICE,allkeys[1]);
--redis.log(redis.LOG_NOTICE,allkeys[2]);
--table.foreachi(allkeys,function(i,v) print(v) end);
end;
