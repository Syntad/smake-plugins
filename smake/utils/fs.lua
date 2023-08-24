local function localizePath(path)
    if platform.is_windows then
        return path:gsub('/', '\\')
    else
        return path:gsub('\\', '/')
    end
end

local smakeFolder = localizePath(platform.is_windows and os.getenv('APPDATA') .. '/Syntad/Smake' or os.getenv('HOME') .. '/.smake')
local pluginsFolder = smakeFolder .. localizePath('/plugins')
local libraryFolder = smakeFolder .. localizePath('/library')

local function RelativePath(path)
    return './' .. path
end

local function Exists(path)
    local ok, err, code = os.rename(path, path)
    return ok or code == 13, err
end

local function CreateFolder(path)
    run('mkdir ' .. path)
end

local function Delete(path)
    run('rm ' .. path )
end

local function DeleteFolder(path)
    run('rm -rf ' .. path)
end

local function Move(from, to)
    run('mv ' .. from .. ' ' .. to)
end

local function ConcatenatePaths(path1, path2)
    return path1 .. '/' .. path2
end

function Plugin.Import()
    return {
        ConstantPaths = {
            SmakeFolder = smakeFolder,
            PluginsFolder = pluginsFolder,
            LibraryFolder = libraryFolder
        },
        RelativePath = RelativePath,
        Exists = Exists,
        CreateFolder = CreateFolder,
        Delete = Delete,
        DeleteFolder = DeleteFolder,
        Move = Move,
        ConcatenatePaths = ConcatenatePaths
    }
end