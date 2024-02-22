local gpp = import('smake/gpp')
local fs = import('smake/utils/fs')
local ninjaGen = {
    mainRules = [[rule cxx
    command = $cxx -MMD -MT $out -MF $out.d $cflags -c $in -o $out
    description = CXX $out
    depfile = $out.d
    deps = gcc
rule link
    command = $cxx -L$builddir -o $out $in $libs
    description = LINK $out]]
}

-- Helpers

function ninjaGen:getInputFiles()
    local inputFiles = {}

    for _, path in next, self.compilerOptions.input do
        local files = fs.Find(path)
        table.move(files, 1, #files, #inputFiles + 1, inputFiles)
    end

    return inputFiles
end

-- Generation

function ninjaGen:generateCFlags()
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

    return cflags:sub(2)
end

function ninjaGen:generateLibs()
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

    return libs:sub(2)
end

-- File utilities

function ninjaGen:writeVariable(name, value)
    self.file:write(name .. ' = ' .. value .. '\n')
end

function ninjaGen:writeBuildRule(input)
    local fileName = input:match('(.+)%.(%w+)$')
    self.file:write(('build $builddir/%s.o: cxx %s'):format(fileName, input) .. '\n')
    self.buildRules = self.buildRules .. '$builddir/' .. fileName .. '.o '
end

function ninjaGen:generateBuildFile(buildDirectory)
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

    self.file:write(self.mainRules .. '\n')

    local inputFiles = self:getInputFiles()
    for _, input in next, inputFiles do
        self:writeBuildRule(input)
    end

    -- Main build rule
    self.file:write('build $builddir/' .. (self.compilerOptions.output or 'a.out') .. ': link ' .. self.buildRules .. '\n')

    self.file:close()
    self.file = nil
end

function ninjaGen.new(compiler)
    return setmetatable({
        compiler = compiler,
        compilerOptions = compiler.options
    }, { __index = ninjaGen })
end

local function generateBuildFile(compiler, buildDirectory)
    local generator = ninjaGen.new(compiler)
    generator:generateBuildFile(buildDirectory)
end

local function fromGlobalCompiler()
    local compiler = gpp()
    compiler:makeGlobal()

    return ninjaGen.new(compiler)
end

function Plugin.Import()
    return setmetatable(
    {
        generateBuildFile = generateBuildFile,
        fromGlobalCompiler = fromGlobalCompiler
    },
    {
        __call = function(self, compiler)
            return ninjaGen.new(compiler)
        end
    })
end