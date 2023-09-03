function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUntar('https://www.lua.org/ftp/lua-5.4.6.tar.gz')
        folder:RunIn('cd src && make' .. (platform.is_windows and ' mingw' or '') .. '> /dev/null > err.log')
        folder:MoveHeaders('src')
        folder:MoveLibraries('src')
        folder:Delete()
    end
end