import('smake/utils/utils', true)
import('smake/utils/fs', true)
import('gpp', true)

local function includeDependency(name)
    local dependencyPath = ConcatenatePaths('./dependencies', name)
    local includeFolder = ConcatenatePaths(dependencyPath, 'include')
    local libFolder = ConcatenatePaths(dependencyPath, 'lib')

    if not Exists(dependencyPath) then
        return
    end

    if Exists(includeFolder) then
        include(includeFolder)
    end

    if Exists(libFolder) then
        local libraries = ExecuteCommand('ls ' .. libFolder, '*all')
        local names = {}

        for lib in libraries:gmatch('%S+') do
            names[#names + 1] = lib:match('lib([^%.]+)%.')
        end

        link(libFolder, table.unpack(names))
    end
end

local function includeDependencies(...)
    local names = {...}

    for _, name in next, names do
        includeDependency(name)
    end
end

function Plugin.Import()
    return {
        IncludeDependency = includeDependency,
        IncludeDependencies = includeDependencies
    }
end