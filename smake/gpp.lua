local utils = import('smake/utils/utils')
local fs = import('smake/utils/fs')

local function bind(method, class)
    return function(...)
        return method(class, ...)
    end
end

local compiler = {
    defaultOptions = {
        compiler = 'g++',
        standard = nil,
        input = {},
        include = {},
        linkPaths = {},
        linkNames = {},
        frameworks = {},
        flags = {},
        output = nil
    }
}

function compiler:compiler(compiler)
    self.options.compiler = compiler
end

function compiler:standard(std)
    self.options.standard = std
end

function compiler:input(...)
    local args = { ... }

    for _, file in next, args do
        self.options.input[#self.options.input + 1] = file
    end
end

function compiler:inputr(folder, extension)
    extension = extension or 'cpp'

    if extension:sub(1, 1) ~= '.' then
        extension = '.' .. extension
    end

    local fileList = utils.ExecuteCommand('ls ' .. folder)
    local found = false

    for file in fileList:lines() do
        local path = fs.ConcatenatePaths(folder, file)

        if fs.Exists(path .. '/') then
            self:inputr(path, extension)
        elseif not found and file:match(extension .. '$') then
            self:input(fs.ConcatenatePaths(folder, '*' .. extension))
            found = true
        end
    end
end

function compiler:include(include, path, name)
    local options = self.options

    if type(include) == 'table' then
        for _, include in next, include do
            options.include[#options.include + 1] = include
        end

        return
    end

    options.include[#options.include + 1] = include
    options.linkPaths[#options.linkPaths + 1] = path
    options.linkNames[#options.linkNames + 1] = name
end

function compiler:link(folder, ...)
    local links

    if type(folder) == 'table' then
        links = folder
    else
        self.options.linkPaths[#self.options.linkPaths + 1] = folder
        links = {...}
    end

    for _, link in next, links do
        self.options.linkNames[#self.options.linkNames + 1] = link
    end
end

function compiler:framework(...)
    local frameworks = {...}

    for _, framework in next, frameworks do
        self.options.frameworks[#self.options.frameworks + 1] = framework
    end
end

function compiler:output(file)
    self.options.output = file
end

function compiler:flags(...)
    local args = { ... }

    for _, flag in next, args do
        self.options.flags[#self.options.flags + 1] = flag
    end
end

function compiler:makeCommand()
    local options = self.options
    local cmd = options.compiler

    if options.standard then
        cmd = cmd .. ' -std=' .. options.standard
    end

    for _, input in next, options.input do
        cmd = cmd .. ' ' .. input
    end

    for _, include in next, options.include do
        cmd = cmd .. ' -I' .. include
    end

    for _, link in next, options.linkPaths do
        cmd = cmd .. ' -L' .. link
    end

    for _, name in next, options.linkNames do
        cmd = cmd .. ' -l' .. name
    end

    for _, framework in next, options.frameworks do
        cmd = cmd .. ' -framework ' .. framework
    end

    for _, flag in next, options.flags do
        cmd = cmd .. ' ' .. flag
    end

    if options.output then
        cmd = cmd .. ' -o' .. options.output
    end

    return cmd
end

function compiler:generateCompileFlags()
    local options = self.options
    local flags = ''

    if options.standard then
        flags = flags .. '-std=' .. options.standard .. '\n'
    end

    for _, include in next, options.include do
        flags = flags .. '-I\n' .. include .. '\n'
    end

    for _, link in next, options.linkPaths do
        flags = flags .. '-L\n' .. link .. '\n'
    end

    for _, name in next, options.linkNames do
        flags = flags .. '-l\n' .. name .. '\n'
    end

    for _, framework in next, options.frameworks do
        flags = flags .. ' -framework\n' .. framework .. '\n'
    end

    for _, flag in next, options.flags do
        for f in flag:gmatch('%S+') do
            flags = flags .. f .. '\n'
        end
    end

    if options.output then
        flags = flags .. '-o\n' .. options.output .. '\n'
    end

    local file = io.open('compile_flags.txt', 'w+')

    if file then
        file:write(flags)
        file:close()
    else
        print('Could not open compile_flags.txt for writing')
    end
end

function compiler:compile()
    run(self:makeCommand())
end

function compiler:makeGlobal()
    for i, v in next, compiler do
        if type(v) == 'function' then
            _G[i] = bind(v, self)
        end
    end
end

local function tableClone(tbl)
    local clone = {}

    for i, v in next, tbl do
        if type(v) == 'table' then
            clone[i] = tableClone(v)
        else
            clone[i] = v
        end
    end

    return clone
end

function Plugin.Import()
    return function()
        return setmetatable({
            options = tableClone(compiler.defaultOptions)
        }, { __index = compiler })
    end
end