local fs = import('smake/utils/fs')
local ninja = {}

local mainRules = [[rule cxx
    command = $cxx -MMD -MT $out -MF $out.d $cflags -c $in -o $out
    description = CXX $out
    depfile = $out.d
    deps = gcc
rule link
    command = $cxx -L$builddir -o $out $in $libs
    description = LINK $out
]]

local buildRule = 'build $builddir/%s.o: cxx %s'

-- Helpers

function ninja:getInputFiles()
    local inputFiles = {}

    for _, path in next, self.compilerOptions.input do
        local files = fs.Find(path)
        table.move(files, 1, #files, #inputFiles + 1, inputFiles)
    end

    return inputFiles
end

-- Generation

function ninja:generateCFlags()
    local options = self.compilerOptions
    local cflags = ''

    if options.standard then
        cflags = cflags .. ' -std=' .. options.standard
    end

    for _, include in next, options.include do
        cflags = cflags .. ' -I' .. include
    end

    for _, flag in next, options.flags do
        cflags = cflags .. ' ' .. flag
    end

    return cflags:match('%s*(.+)')
end

function ninja:generateLibs()
    local options = self.compilerOptions
    local libs = ''

    for _, link in next, options.linkPaths do
        libs = libs .. ' -L' .. link
    end

    for _, name in next, options.linkNames do
        libs = libs .. ' -l' .. name
    end

    for _, framework in next, options.frameworks do
        libs = libs .. ' -framework ' .. framework
    end

    return libs:match('%s*(.+)')
end

-- File utilities

function ninja:writeVariable(name, value)
    self.file:write(name .. ' = ' .. value .. '\n')
end

function ninja:writeBuildRule(input)
    local fileName = input:match('(.+)%.(%w+)$')
    self.file:write(buildRule:format(fileName, input) .. '\n')
    self.buildRules = self.buildRules .. '$builddir/' .. fileName .. '.o '
end

function ninja:generateBuildFile(buildDirectory)
    buildDirectory = buildDirectory or '.'

    self.file = io.open('build.ninja', 'w+')
    self.buildRules = ''

    if not self.file then
        return false
    end

    -- Variables
    self:writeVariable('builddir', buildDirectory)
    self:writeVariable('cxx', self.compilerOptions.compiler)
    self:writeVariable('cflags', self:generateCFlags())
    self:writeVariable('libs', self:generateLibs())

    self.file:write(mainRules)

    local inputFiles = self:getInputFiles()
    for _, input in next, inputFiles do
        self:writeBuildRule(input)
    end

    -- Main build rule
    self.file:write('build $builddir/out.a: link ' .. self.buildRules .. '\n')

    self.file:close()
    self.file = nil
end

function Plugin.Import()
    ---@type fun(compiler: compiler)
    return function(compiler)
        return setmetatable({
            compiler = compiler,
            compilerOptions = compiler.options
        }, { __index = ninja })
    end
end