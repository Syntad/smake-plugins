local pluginsFolder = platform.is_windows and os.getenv('APPDATA') .. '\\Syntad\\Smake\\plugins' or '$HOME/.smake/plugins'

function Plugin.Command()
    run(
        'curl "https://github.com/Syntad/smake-plugins/archive/refs/heads/main.zip" -L -o ./plugins.zip',
        'unzip -q ./plugins.zip',
        'rm ./plugins.zip',
        'rm -rf "' .. pluginsFolder .. '/smake/*"',
        'mv ./smake-plugins-main/*.lua "' .. pluginsFolder .. '/smake"'
    )
end