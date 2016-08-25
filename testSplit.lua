#/usr/bin/lua

string.split = function(s,p)
  local rt = {}
  string.gsub(s,'[^'..p..']+', function(w) table.insert(rt, w) end)
  return rt
end


local str = 'abc,123,hello,ok'
local list = string.split(str,',')
for _,s in ipairs(list) do
  print(s)
end
