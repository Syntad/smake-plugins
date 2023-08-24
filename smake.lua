import('smake/dependencyInstaller', true)

function smake.install()
    InstallDependency('lua')
end

function smake.build()
    smake.install()
end