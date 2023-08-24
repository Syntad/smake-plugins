function Plugin.Import()
    return 'lua',
    --- @type fun(installer: installer)
    function(installer)
        local folder = installer:DownloadAndUntar('https://www.lua.org/ftp/lua-5.4.4.tar.gz')
        folder:RunIn('cd src && make' .. (platform.is_windows and ' mingw' or '') .. '> /dev/null > err.log')

        installer:MakeIncludeFolder()
        folder:MoveInclude('src/*.h')
        folder:MoveInclude('src/*.hpp')

        installer:MakeLibraryFolder()
        folder:MoveLibrary('src/*.a')

        folder:Delete()
    end
end