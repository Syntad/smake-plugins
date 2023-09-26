function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/glennrp/libpng/archive/refs/heads/libpng16.zip')
        folder:RunIn('sh configure && make')

        folder:MoveLibrary('.libs/libpng16.a')
        folder:MoveHeaders()

        folder:Delete()
    end
end