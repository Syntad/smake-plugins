local pluginsFolder = platform.is_windows and '%APPDATA%\\Syntad\\Smake\\plugins' or '$HOME/.smake/plugins'

function Plugin.Command()
    run(
        'curl "https://github.com/Syntad/smake-plugins/archive/refs/heads/main.zip" -L -o plugins.zip',
        'tar -xf plugins.zip',
        'rm plugins.zip',
        'mv ./smake-plugins-main ' .. pluginsFolder .. '/smake'
    )
end