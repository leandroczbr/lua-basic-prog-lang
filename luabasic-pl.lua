local dbg = false --SET TRUE TO DEBUG CODE

------------ functions
function t_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end
function t_find(t,v)
    for k, value in pairs(t) do
        if value == v then
            return k
        end
    end
end
function t_glue(t,...)
    local index = #t
    for _, othertable in pairs(...) do
        if type(othertable) == "table" then
            for otindex = 1, #othertable do
                table.insert(t,index+otindex,othertable[otindex]) 
            end
            index = index + #othertable
        else
            index = index+1
            table.insert(t,index,othertable)
        end
    end
    return t
end
function s_glue(s,...)
    for _, v in pairs({...}) do
        if type(v) == "table" then
            for i = 1, #v do
                s=s..tostring(v[i])
                if i < #v then
                    s= s..","
                end
            end
        else
            s = s..tostring(v)
        end
    end
    return s
end
---------- code to tokens
function matchmult(inputstr,...)
    patterns = {...}
    local indexes = {}
    local index = 0
    while true do
        local possibleend = #inputstr+1
        local possiblestart = #inputstr
        for _, pattern in pairs(patterns) do
            local wordstart, wordend = string.find(inputstr,pattern,index)
            if wordstart and wordstart < possiblestart then
                possiblestart = wordstart
                possibleend = wordend
            end
        end
        table.insert(indexes,string.sub(inputstr,possiblestart,possibleend))
        inputstr = string.sub(inputstr,possibleend+1)
        if inputstr == "" then break end
    end
    return indexes
end
function stringtotoken(code)
    local keys={}
    for key,_ in pairs(comlua.builtincommands) do
        table.insert(keys, key)
    end
    
    code = matchmult(code,"%d+","%w+",";",":",unpack(keys))
    for i, v in pairs(code) do
        v = tonumber(v) and tonumber(v) or v
    end
    return code
end
--------- programming language
comlua = {
    ["env"] = {},
    ["print"] = function(...) print("comlua: ",...) end ,
    ["error"] = function(...) print("comlua error:",...) end
}
local index, code

local function fvar(var)
    if tonumber(var) then
        return tonumber(var)
    elseif comlua.env[var] ~= nil then
        return comlua.env[var]
    elseif var == "true" then
        return true
    elseif var == "false" then
        return false
    else
        comlua.error(tostring(var).. " is a "..type(var))
        return var
    end
end
local function fvars(...)
    local args = {...}
    
    for i, v in pairs(args) do
        args[i] = fvar(v)
    end
    return unpack(args)
end
local function pl_add(co,a,b,...)
    args = {...}
    if #args > 0 then
        local count = fvar(b)
        for _, v in pairs{...} do
            count = count + fvar(v)
        end
        comlua.env[a] = count
    else
        comlua.env[a] = comlua.env[a] + fvar(b)
    end
end
local function pl_sub(co,a,b,...)
    args = {...}
    if #args > 0 then
        local count = fvar(b)
        for _, v in pairs{...} do
            count = count - fvar(v)
        end
        comlua.env[a] = count
    else
        comlua.env[a] = comlua.env[a] - fvar(b)
    end
end
local function pl_mul(co,a,b,...)
    args = {...}
    if #args > 0 then
        local count = fvar(b)
        for _, v in pairs{...} do
            count = count * fvar(v)
        end
        comlua.env[a] = count
    else
        comlua.env[a] = comlua.env[a] * fvar(b)
    end
end
local function pl_div(co,a,b,...)
    args = {...}
    if #args > 0 then
        local count = fvar(b)
        for _, v in pairs{...} do
            count = count / fvar(v)
        end
        comlua.env[a] = count
    else
        comlua.env[a] = comlua.env[a] / fvar(b)
    end
end
local function pl_equ(co,a,b,...)
    args = {...}
    if #args > 0 then
        comlua.env[a] = true
        local indicator = fvar(b)
        for _, v in pairs{...} do
            if indicator ~= fvar(v) then
                comlua.env[a] = false
                break
            end
        end
    else
        comlua.env[a] = comlua.env[a] == fvar(b)
    end
end
local function pl_not(co,a,b,...)
    args = {...}
    if #args > 0 then
        comlua.env[a] = true
        local indicator = fvar(b)
        for _, v in pairs{...} do
            if indicator == fvar(v) then
                comlua.env[a] = false
                break
            end
        end
    else
        comlua.env[a] = comlua.env[a] ~= fvar(b)
    end
end
local function pl_big(co,a,b,...)
    args = {...}
    if #args > 0 then
        comlua.env[a] = true
        local indicator = fvar(b)
        for _, v in pairs{...} do
            if indicator <= fvar(v) then
                comlua.env[a] = false
                break
            end
        end
    else
        comlua.env[a] = comlua.env[a] > fvar(b)
    end
end
local function pl_sml(co,a,b,...)
    args = {...}
    if #args > 0 then
        comlua.env[a] = true
        local indicator = fvar(b)
        for _, v in pairs{...} do
            if indicator >= fvar(v) then
                comlua.env[a] = false
                break
            end
        end
    else
        comlua.env[a] = comlua.env[a] < fvar(b)
    end
end
local function pl_goto(co,a)
    co.index = co.gotos[a] or comlua.error(a.." is not a goto key")
end
local function pl_ifgt(co,a,b)
    if fvar(a) == true then
        co.index = co.gotos[b] or comlua.error(b.." is not a goto key")
    end
end
comlua.builtincommands = {
    ["add"] = pl_add,
    ["sub"] = pl_sub,
    ["mul"] = pl_mul,
    ["div"] = pl_div,
    ----------- boolean
    ["equ"] = pl_equ,
    ["not"] = pl_not,
    --------
    ["big"] = pl_big,
    ["sml"] = pl_sml,
    ----------
    ["set"] = function(co,a, b) comlua.env[a] = fvar(b) end,
    ["goto"] = pl_goto,
    ["ifgt"] = pl_ifgt,
    ["print"] = function(co,...)comlua.print(fvars(...)) end
}
local function call(codeenv,com,name)
    ------ get args
    local args = {}
    for argindex = codeenv.index+1, #codeenv.code do
        if codeenv.code[argindex] == ";" then
            break
        end
        table.insert(args,codeenv.code[argindex])
    end
    ------
    if dbg then print(s_glue("",codeenv.index,": ",name,"(",args,")")) end
    return com(codeenv,unpack(args))
end

local function unsecuredotoken(tokens)
    local codeenv = {index = 0,code = t_copy(tokens),gotos = {}}
    
    for index = 1, #codeenv.code do
        if codeenv.code[index] == ":" then
            codeenv.gotos[codeenv.code[index+1]]=index
        end
    end
    
    
    while true do
        codeenv.index = codeenv.index + 1
        command = codeenv.code[codeenv.index]
        if comlua.builtincommands[command] then
            call(codeenv,comlua.builtincommands[command],command)
        end
        if command == nil then
            break
        end
    end
end

local function dotoken(tokens)
    local sus, err = pcall(unsecuredotoken,tokens)
    if not sus then
        comlua.error(err)
    end
end

function comlua.run(code)
    dotoken(stringtotoken(code))
end

comlua.fvar = fvar
comlua.fvars = fvars

-------
return comlua
