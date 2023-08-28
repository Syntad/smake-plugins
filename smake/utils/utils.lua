local function ExecuteCommand(cmd, read)
    read = read or '*line'
    local success, pfile, err = pcall(io.popen, cmd)

    if not success then
        local tmpPath = os.tmpname()
        local file, err = io.open(tmpPath, 'w+')
        assert(file, 'Could not open file. Error: ' .. (err or ''))

        os.execute(cmd .. '>"' .. tmpPath .. '"')
        local content = file:read(read)
        file:close()
        os.remove(tmpPath)

        return content
    end

    assert(pfile, 'Could not execute popen. Error: "' .. (err or '') .. '"')

    local content = pfile:read(read)
    pfile:close()

    return content
end

function Plugin.Import()
    return {
        ExecuteCommand = ExecuteCommand
    }
end