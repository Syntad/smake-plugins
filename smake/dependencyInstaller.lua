local config = smake.config.dependencyInstaller or {}
local fs = import('smake/utils/fs')

---@diagnostic disable: undefined-global
-- #region Util

local function download(url, path, extension)
    run('curl ' .. (config.silent and '-s ' or '') .. '"' .. url .. '" -L -o "./' .. path .. '"' .. extension)
end

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

local function getTarFolderName(path)
    return popen('tar -tf "./' .. path ..  '.tar" | head -1'):gsub('/.*', '')
end

local function getZipFolderName(path)
    return popen('unzip -qql "./' .. path ..  '.zip" | head -1'):match('(%S+)$'):gsub('/$', '')
end

local function untar(name)
    run(
        'tar -xf "./' .. name .. '.tar"',
        'rm "./' .. name .. '.tar"'
    )
end

local function unzip(name)
    run(
        'unzip -q "./' .. name .. '.zip"',
        'rm "./' .. name .. '.zip"'
    )
end

-- #endregion

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
    fs.CreateFolder(path)

    return path
end

--- Creates a library folder in the dependency folder
--- @return string Returns the path to the created folder
function installer:MakeLibraryFolder()
    local path = fs.RelativePath(self:ConcatenatePath('lib'))
    fs.CreateFolder(path)

    return path
end

--- Downloads and extracts a tar file from a URL
---@param url any The url to download the tar from
---@return table A folder object for the extracted folder
function installer:DownloadAndUntar(url)
    download(url, self.name, '.tar')
    local folderName = getTarFolderName(self.name)
    untar(self.name)

    return createFolder(self, folderName)
end


--- Downloads and extracts a zip from a URL
---@param url any The url to download the zip from
---@return table A folder object for the unzipped folder
function installer:DownloadAndUnzip(url)
    -- Use tar -xf on Windows instead of unzip
    if platform.is_windows then
        return self:DownloadAndUntar(url)
    end

    download(url, self.name, '.zip')
    local folderName = getZipFolderName(self.name)
    unzip(self.name)

    return createFolder(self, folderName)
end

-- #endregion

local function installDependency(name, callback)
    if not callback then
        local presetName, callback = import('smake/dependencyInstallers/' .. name:lower())

        if presetName then
            return InstallDependency(presetName, callback)
        else
            return print('Preset "' .. name .. '" does not exist.')
        end
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

function Plugin.Import()
    return {
        InstallDependency = installDependency
    }
end