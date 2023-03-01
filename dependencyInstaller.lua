---@diagnostic disable: undefined-global
-- #region Util

local function relPath(path)
    return './' .. path
end

local function exists(file)
    local ok, err, code = os.rename(file, file)
    return ok or code == 13, err
end

local function download(url, path)
    run('curl "' .. url .. '" -L -o "./' .. path .. '"')
end

local function getZipFolderName(path)
    local pfile = io.popen('tar -tf "./' .. path ..  '" | head -1')
    local folderName = pfile:lines()():gsub('/.*', '')
    pfile:close()

    return folderName
end

local function unzip(path)
    run(
        'tar -xf "./' .. path .. '"',
        'rm "./' .. path .. '"'
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
    if not self.valid or not exists(self.path) then
        error('Attempt to call a method on an invalid folder')
    end
end

--- Moves a file from the folder to another path
--- @param relFrom any A path relative to the folder
--- @param to any A path to move the item to
--- @return folder self
function folder:Move(relFrom, to)
    self:CheckValidity()
    print('mv ' .. relPath(self:ConcatenatePath(relFrom)) .. ' ' .. relPath(to))
    run('mv ' .. relPath(self:ConcatenatePath(relFrom)) .. ' ' .. relPath(to))
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
    run('mv ' .. relPath(self.path) .. ' ' .. relPath(newPath))
    self.path = newPath
    return self
end

--- Deletes the folder and invalidates it
--- @return folder self
function folder:Delete()
    self:CheckValidity()
    run('rm -rf ' .. relPath(self.path))
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
    run('mv ' .. relPath(self:ConcatenatePath(relFrom)) .. ' ' .. relPath(to))
end

--- Creates an include folder in the dependency folder
--- @return string Returns the path to the created folder
function installer:MakeIncludeFolder()
    local path = relPath(self:ConcatenatePath('include'))
    run('mkdir ' .. path)

    return path
end

--- Creates a library folder in the dependency folder
--- @return string Returns the path to the created folder
function installer:MakeLibraryFolder()
    local path = relPath(self:ConcatenatePath('lib'))
    run('mkdir ' .. path)

    return path
end

--- Downloads and unzips a zip from a URL
---@param url any The url to download the zip from
---@return table A folder object for the unzipped folder
function installer:DownloadAndUnzip(url)
    download(url, self.name)
    local folderName = getZipFolderName(self.name)
    unzip(self.name)
    print(folderName)

    return createFolder(self, folderName)
end

-- #endregion

local function installDependency(name, callback)
    if not exists('./dependencies') then
        run('mkdir ./dependencies')
    elseif exists('./dependencies/' .. name) then
        print('Dependency "' .. name .. '" is already installed')
        return
    end

    run('mkdir ' .. relPath('dependencies/' .. name))

    callback(createInstaller(name))
end

function Plugin.Import()
    return {
        InstallDependency = installDependency
    }
end