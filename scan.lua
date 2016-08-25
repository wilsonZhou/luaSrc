local keys = {}
redis.replicate_commands();
redis.call('select',9)
local result = redis.call('scan', '0', 'match', '*_*_*', 'count',10);
local cursor = result[1];
keys = result[2]

for i, key in ipairs(keys) do
  redis.log(redis.LOG_NOTICE,key);
  redis.call('select',12);
  redis.call('incrby','count', 1)
end

return true;
