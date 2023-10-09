local commandResult = {}

function commandResult:__gc()
    if not self.file or self.closed then
        return
    end

    self.file:close()

    if self.tmpPath then
        os.remove(self.tmpPath)
    end

    self.closed = true
end

function commandResult:__index(index)
    if self.file[index] then
        if type(self.file[index]) == 'function' then
            return function(_self, ...)
                if _self == self then
                    -- If it is being called as a member function
                    return self.file[index](self.file, ...)
                else
                    -- If it is being called as a static function
                    return self.file[index](_self, ...)
                end
            end
        else
            return self.file[index]
        end
    end

    return rawget(self, index)
end

local function ExecuteCommand(cmd)
    local success, pfile, err = pcall(io.popen, cmd)

    if not success then
        local tmpPath = os.tmpname()
        local file, err = io.open(tmpPath, 'w+')
        assert(file, 'Could not open file. Error: ' .. (err or ''))

        os.execute(cmd .. '>"' .. tmpPath .. '"')

        return setmetatable({
            file = file,
            tmpPath = tmpPath
        }, commandResult)
    end

    assert(pfile, 'Could not execute popen. Error: "' .. (err or '') .. '"')

    return setmetatable({
        file = pfile
    }, commandResult)
end

function Plugin.Import()
    return {
        ExecuteCommand = ExecuteCommand
    }
end