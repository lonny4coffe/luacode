--[[
data= {1,2,3,4,5,6}
print(table.concat(data,"-"))

data= {["a"]=a, ["b"]=b}
print(table.concat(data,"-"))

]]--

--serizlize = table to string 
function serialize(object)
    local lua = ""
    local  t   = type(object)
    if t == "number"      then
        lua = lua .. object                           --string + number = string
    elseif t == "boolean" then
        lua = lua .. tostring(object)                 --string + tostring(boolean)
    elseif t == "string"  then
        lua = lua .. string.format("%q", object)      --string + string.format
    elseif t == "table"   then
        lua = lua .. "{\n"                            --string + {
        for k,v in pairs(object)  do
            lua = lua .. "[" ..serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
        local metatable = getmetatable(object)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k,v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .."]" .. serialize(v) .. ",\n"
            end
        end
        lua = lua .. "}"                              --string + }
    elseif t == "nil" then 
        return nil
    else
        error("cannot serizalze a" .. t .. "type")
    end
    return lua
end


--unserialize = string to table
function unserialize(luastring)
    local t = type(luastring)
    local luaobjectstr = ""
    if t == "nil" or luastring == "" then             --empty string
        return nil
    elseif t == "number" or t == "string" or t=="boolean" then
        luaobjectstr = tostring(luastring)
    else 
        error("cannot unserialize a " .. t .. "type.")
    end
    luaobjectstr = "return " .. luaobjectstr          --return is a must have for call=loadstring

    local func = loadstring(luaobjectstr)
    if func == nil then 
        return nil 
    end
    return func()
end


--test code
local data = {["a"]= "a", ["b"]="b", [1]=1,[2]=2, ["t0"] = {1,2,3},["t0"] = {"x","y","z"},["t1"] = {1,2,3},["t2"] = {"x","y","z"}}
local szstring = serialize(data)
print(szstring)
print("------------------------------")

local uszobj = unserialize(szstring)
print(uszobj)
print("uszobj type = " .. type(uszobj))

print(serialize(uszobj))
