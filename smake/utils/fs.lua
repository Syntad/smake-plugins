local function localizePath(path)
    if platform.is_windows then
        return path:gsub('[\\/]', '\\\\')
    else
        return path:gsub('\\', '/')
    end
end

local smakeFolder = localizePath(platform.is_windows and os.getenv('APPDATA') .. '/Syntad/Smake' or os.getenv('HOME') .. '/.smake')
local pluginsFolder = smakeFolder .. localizePath('/plugins')
local libraryFolder = smakeFolder .. localizePath('/library')

-- Helpers

local function popen(cmd)
    local success, pfile, err = pcall(io.popen, cmd)

    if not success then
        local tmpPath = os.tmpname()
        local file, err = io.open(tmpPath, 'w+')
        assert(file, 'Could not open file. Error: ' .. (err or ''))

        os.execute(cmd .. '>"' .. tmpPath .. '"')
        local line = file:read('l')
        file:close()
        os.remove(tmpPath)

        return line
    end

    assert(pfile, 'Could not execute popen. Error: "' .. (err or '') .. '"')

    local line = pfile:lines()()
    pfile:close()

    return line
end

-- Shared

local function Exists(path)
    local ok, err, code = os.rename(path, path)
    return ok or code == 13, err
end

local function Move(from, to)
    run('mv ' .. from .. ' ' .. to)
end

-- Folders

local function CreateFolder(path)
    run('mkdir ' .. path)
end

local function DeleteFolder(path)
    run('rm -rf ' .. path)
end

-- Files

local function Delete(path)
    run('rm ' .. path )
end

-- Paths

local function RelativePath(path)
    return './' .. path
end

local function ConcatenatePaths(path1, path2)
    return path1 .. '/' .. path2
end

-- Tar Utilities

local function Untar(path)
    run('tar -xf ' .. path)
end

local function UntarAndDelete(path)
    Untar(path)
    Delete(path)
end

local function GetTarFolderName(path)
    return popen('tar -tf ' .. path ..  ' | head -1'):gsub('/.*', '')
end

-- Zip Utilities

local function Unzip(path)
    if platform.is_windows then
        return Untar(path)
    end

    run('unzip -q ' .. path)
end

local function UnzipAndDelete(path)
    Unzip(path)
    Delete(path)
end

local function GetZipFolderName(path)
    if platform.is_windows then
        return GetTarFolderName(path)
    end

    return popen('unzip -qql ' .. path ..  ' | head -1'):match('(%S+)$'):gsub('/$', '')
end

-- Downloads

local function Download(url, outputPath, silent)
    run('curl ' .. (silent and '-s ' or '') .. '"' .. url .. '" -L -o ' .. outputPath)
end

function Plugin.Import()
    return {
        ConstantPaths = {
            SmakeFolder = smakeFolder,
            PluginsFolder = pluginsFolder,
            LibraryFolder = libraryFolder
        },
        Exists = Exists,
        CreateFolder = CreateFolder,
        Delete = Delete,
        DeleteFolder = DeleteFolder,
        Move = Move,
        RelativePath = RelativePath,
        ConcatenatePaths = ConcatenatePaths,
        Untar = Untar,
        UntarAndDelete = UntarAndDelete,
        GetTarFolderName = GetTarFolderName,
        Unzip = Unzip,
        UnzipAndDelete = UnzipAndDelete,
        GetZipFolderName = GetZipFolderName,
        Download = Download
    }
end