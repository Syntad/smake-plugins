---@diagnostic disable: undefined-global
local config = smake.config.dependencyInstaller or {}
local fs = import('smake/utils/fs')

-- #region Folder Class

local folder = {}

local function createFolder(installer, path)
    return setmetatable({ installer = installer, path = path, valid = true }, { __index = folder })
end

function folder:ConcatenatePath(path)
    return self.path .. '/' .. path
end

function folder:CheckValidity()
    if not self.valid or not fs.Exists(self.path) then
        error('Attempt to call a method on an invalid folder')
    end
end

--- Moves a file from the folder to another path
--- @param relFrom any A path relative to the folder
--- @param to any A path to move the item to
--- @return folder self
function folder:Move(relFrom, to)
    self:CheckValidity()
    fs.Move(fs.RelativePath(self:ConcatenatePath(relFrom)), fs.RelativePath(to))
    return self
end

--- Moves the include folder to the dependency folder
--- @param path any A relative path to the include folder or nil for `include`
--- @return folder self
function folder:MoveInclude(path)
    self:Move(path or 'include', self.installer:ConcatenatePath('include'))
    return self
end

--- Moves the library folder to the dependency folder
---@param path any A relative path to the lib folder or nil for `lib`
--- @return folder self
function folder:MoveLibrary(path)
    self:Move(path or 'lib', self.installer:ConcatenatePath('lib'))
    return self
end

--- Moves the library file to the dependency library folder
---@param path any A relative path to the lib file
--- @return folder self
function folder:MoveLibraryFile(path)
    self:Move(path, fs.ConcatenatePaths(self.installer:ConcatenatePath('lib'), path))
    return self
end

--- Run commmand(s) in the folder
---@param ... string The commands to run
--- @return folder self
function folder:RunIn(...)
    self:CheckValidity()
    runIn(self.path, ...)
    return self
end

--- Renames the folder and updates the path property
--- @param newPath any The name or path to move it to
--- @return folder self
function folder:Rename(newPath)
    self:CheckValidity()
    fs.Move(fs.RelativePath(self.path), fs.RelativePath(newPath))
    self.path = newPath
    return self
end

--- Deletes the folder and invalidates it
--- @return folder self
function folder:Delete()
    self:CheckValidity()
    fs.DeleteFolder(fs.RelativePath(self.path))
    self.valid = false
    return self
end

-- #endregion

-- #region Installer Class

local installer = {}

local function createInstaller(name)
    return setmetatable({ name = name }, { __index = installer })
end

function installer:ConcatenatePath(path)
    return 'dependencies/' .. self.name .. '/' .. path
end

--- Moves a file from the dependency folder to another path
--- @param relFrom any A path relative to the dependency folder
--- @param to any A path to move the item to
function installer:Move(relFrom, to)
    fs.Move(fs.RelativePath(self:ConcatenatePath(relFrom)), fs.RelativePath(to))
end

--- Creates an include folder in the dependency folder
--- @return string Returns the path to the created folder
function installer:MakeIncludeFolder()
    local path = fs.RelativePath(self:ConcatenatePath('include'))

    if not fs.Exists(path) then
        fs.CreateFolder(path)
    end

    return path
end

--- Creates a library folder in the dependency folder
--- @return string Returns the path to the created folder
function installer:MakeLibraryFolder()
    local path = fs.RelativePath(self:ConcatenatePath('lib'))

    if not fs.Exists(path) then
        fs.CreateFolder(path)
    end

    return path
end

--- Downloads and extracts a tar file from a URL
---@param url any The url to download the tar from
---@return table A folder object for the extracted folder
function installer:DownloadAndUntar(url)
    local path = self.name .. '.tar'
    fs.Download(url, path)
    local folderName = fs.GetTarFolderName(path)
    fs.UntarAndDelete(path)

    return createFolder(self, folderName)
end

--- Downloads and extracts a zip from a URL
---@param url any The url to download the zip from
---@return table A folder object for the unzipped folder
function installer:DownloadAndUnzip(url)
    local path = self.name .. '.zip'
    fs.Download(url, path)
    local folderName = fs.GetZipFolderName(path)
    fs.UnzipAndDelete(path)

    return createFolder(self, folderName)
end

-- #endregion

local function installDependency(name, callback)
    callback = callback or import('smake/dependencyInstallers/' .. name:lower())

    if not callback then
        return
    end

    if not fs.Exists('./dependencies') then
        run('mkdir ./dependencies')
    elseif fs.Exists('./dependencies/' .. name) then
        if config.log then
            print('Dependency "' .. name .. '" is already installed')
        end

        return
    end

    fs.CreateFolder(fs.RelativePath('dependencies/' .. name))

    callback(createInstaller(name))
end

local function installDependencies(...)
    local names = {...}

    for _, name in next, names do
        installDependency(name)
    end
end

function Plugin.Import()
    return {
        InstallDependency = installDependency,
        InstallDependencies = installDependencies
    }
end