local function exists(file)
    local ok, err, code = os.rename(file, file)
    return ok or code == 13, err
end

local function createFolder()
    if not exists('./smake') then
        run('mkdir ./smake')
    end

    if not exists('./smake/library') then
        run('mkdir ./smake/library')
    end
end

local function hasLibrary(name)
    name = name:match('^smake/(.+)') or name

    return exists('./smake/library/' .. name .. '.lua')
end

--- Installs a library based on the plugin name. Assumes getLibraries has been called.
local function addLibrary(name)
    name = name:match('^smake/(.+)') or name

    if hasLibrary(name) then
        return
    end

    run('curl "https://raw.githubusercontent.com/Syntad/smake-lsp-library/main/library/plugins/' .. name .. '.lua" -o ./smake/library/' .. name .. '.lua')
end

function Plugin.Command(...)
    local names = {...}

    createFolder()

    for _, name in next, names do
        addLibrary(name)
    end
end

local function customImport(name, global)
    createFolder()
    addLibrary(name)

    return import(name, global)
end

function Plugin.Import()
    return customImport
end