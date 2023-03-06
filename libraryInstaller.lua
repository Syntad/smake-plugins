local function exists(file)
    local ok, err, code = os.rename(file, file)
    return ok or code == 13, err
end

local function getLibraries()
    if not exists('./smake') then
        run('mkdir ./smake')
    end

    if not exists('./smake/library') then
        run('mkdir ./smake/library')
    end

    run(
        'curl "https://github.com/Syntad/smake-lsp-library/archive/refs/heads/main.zip" -L -o ./library.zip',
        'tar -xf ./library.zip',
        'rm ./library.zip'
    )
end

local function deleteLibraries()
    run('rm -rf ./smake-lsp-library-main')
end

local function hasLibrary(name)
    return exists('./smake/library/plugins/' .. name .. '.lua')
end

--- Installs a library based on the plugin name. Assumes getLibraries has been called.
local function addLibrary(name)
    name = name:match('^smake/(.+)') or name

    if exists('./smake-lsp-library-main/library/plugins/' .. name .. '.lua') then
        run('mv ./smake-lsp-library-main/library/plugins/' .. name .. '.lua ./smake/library/' .. name .. '.lua')
    end
end

function Plugin.Command(...)
    local names = {...}

    getLibraries()

    for _, name in next, names do
        addLibrary(name)
    end

    deleteLibraries()
end

local function customImport(name, global)
    if not hasLibrary(name) then
        getLibraries()
        addLibrary(name)
        deleteLibraries()
    end

    return import(name, global)
end

function Plugin.Import()
    return customImport
end