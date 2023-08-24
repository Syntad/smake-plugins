import('smake/utils/fs', true)

function Plugin.Command()
    Download('https://github.com/Syntad/smake-plugins/archive/refs/heads/main.zip', './plugins.zip')
    UnzipAndDelete('./plugins.zip')
    DeleteFolder(ConstantPaths.PluginsFolder .. '/smake')
    Move('./smake-plugins-main/smake', ConstantPaths.PluginsFolder .. '/smake')
    DeleteFolder('./smake-plugins-main')
end