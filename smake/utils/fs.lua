local function localizePath(path)
    if platform.is_windows then
        return path:gsub('[\\/]', '\\\\')
    else
        return path:gsub('\\', '/')
    end
end

local utils = import('smake/utils/utils.lua')
local smakeFolder = localizePath(platform.is_windows and os.getenv('APPDATA') .. '/Syntad/Smake' or os.getenv('HOME') .. '/.smake')
local pluginsFolder = smakeFolder .. localizePath('/plugins')
local libraryFolder = smakeFolder .. localizePath('/library')

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
    return utils.ExecuteCommand('tar -tf ' .. path ..  ' | head -1'):gsub('/.*', '')
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

    return utils.ExecuteCommand('unzip -qql ' .. path ..  ' | head -1'):match('(%S+)$'):gsub('/$', '')
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