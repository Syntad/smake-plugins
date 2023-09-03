function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/madler/zlib/archive/refs/heads/develop.zip')
        folder:RunIn('perl configure && make')
        folder:MoveHeaders()
        folder:MoveLibraries()
        folder:Delete()
    end
end