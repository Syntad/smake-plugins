local pluginsFolder = import('smake/utils/fs').ConstantPaths.PluginsFolder

function Plugin.Command()
    run(
        'curl "https://github.com/Syntad/smake-plugins/archive/refs/heads/main.zip" -L -o ./plugins.zip',
        'unzip -q ./plugins.zip',
        'rm ./plugins.zip',
        'rm -rf "' .. pluginsFolder .. '/smake"',
        'mv ./smake-plugins-main/smake "' .. pluginsFolder .. '/smake"',
        'rm -rf ./smake-plugins-main'
    )
end