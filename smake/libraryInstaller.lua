local globalLibrariesFolder = import('smake/utils/fs').ConstantPaths.LibraryFolder .. '/'
local fs = import('smake/utils/fs')

local function createFolders()
    if not fs.Exists('./smake') then
        fs.CreateFolder('./smake')
    end

    if not fs.Exists('./smake/library') then
        fs.CreateFolder('./smake/library')
    end
end

--- Installs a library based on the plugin name. Assumes getLibraries has been called.
local function addLibrary(name, global)
    name = name:match('^smake/(.+)') or name
    local librariesPath = (global and globalLibrariesFolder or './smake/library/')
    local libraryPath = librariesPath .. name .. '.lua'
    local directory = name:match('(.+)/')

    if directory then
        run('mkdir -p ' .. fs.ConcatenatePaths(librariesPath, directory))
    end

    if not fs.Exists(libraryPath) then
        run('curl "https://raw.githubusercontent.com/Syntad/smake-lsp-library/main/library/plugins/' .. name .. '.lua" -o ' .. libraryPath)
    end
end

function Plugin.Command(...)
    local names = {...}
    local global = false

    for i, name in next, names do
        if name == '--global' then
            global = true
            table.remove(names, i)
            break
        end
    end

    if not global then
        createFolders()
    end

    for _, name in next, names do
        addLibrary(name, global)
    end
end

local function customImport(name, global)
    createFolders()
    addLibrary(name)

    return import(name, global)
end

local function importGlobal(...)
    local plugins = {...}

    for _, name in next, plugins do
        customImport(name, true)
    end
end

function Plugin.Import()
    return customImport, importGlobal
end