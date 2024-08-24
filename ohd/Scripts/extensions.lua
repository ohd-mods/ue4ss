-- Define a new table to hold our extensions
local StringExtensions = {}

-- Convert the starts function into an extension method
function StringExtensions:starts(str)
    return self:sub(1, #str) == str
end

-- Convert the startswith function into an extension method
function StringExtensions:startswith(str)
    return self:find('^' .. str) ~= nil
end

-- Convert the split function into an extension method
function StringExtensions:split(sep)
    if not type(self) == 'string' then return {} end
    sep = sep or ":"
    local pattern = "([^"..sep.."]+)"
    local result = {}
    self:gsub(pattern, function(c) table.insert(result, c) end)
    return result
end

local TableExtensions = {}

-- Convert the join function into an extension method
function TableExtensions:join(sep)
    if not type(self) == 'table' then return "" end
    sep = sep or ","
    return table.concat(self, sep)
end

-- Convert the dump function into an extension method
function TableExtensions:dump()
    if type(self) == 'table' then
        local s = "{ "
        for k, v in pairs(self) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. "["..k.."] = " .. (type(v) == 'table' and dump(v) or tostring(v)) .. ","
        end
        return s .. "} "
    else
        return tostring(self)
    end
end

-- Attach our extensions to the global string and table namespaces
setmetatable(string, { __index = StringExtensions })
setmetatable(table, { __index = TableExtensions })

-- Traditional function to check if a string starts with another string
function startsWith(originalString, startsString)
    return originalString:sub(1, #startsString) == startsString
end

-- Traditional function to split a string by a separator
function splitString(inputString, separator)
    if type(inputString) ~= 'string' then return {} end
    separator = separator or ":"
    local pattern = "([^"..separator.."]+)"
    local result = {}
    inputString:gsub(pattern, function(c) table.insert(result, c) end)
    return result
end

-- Traditional function to join elements of a table with a separator
function joinTable(elements, separator)
    if type(elements) ~= 'table' then return "" end
    separator = separator or ","
    return table.concat(elements, separator)
end

-- Traditional function to dump a table contents
function dumpTable(tbl)
    if type(tbl) == 'table' then
        local s = "{ "
        for k, v in pairs(tbl) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. "["..k.."] = " .. (type(v) == 'table' and dumpTable(v) or tostring(v)) .. ","
        end
        return s .. "} "
    else
        return tostring(tbl)
    end
end
