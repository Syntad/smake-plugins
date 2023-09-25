function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.zip')
        folder:RunIn('make')
        folder:MoveIncludeFolder()
        folder:MoveLibrary('lib/libGLEW.a')
        folder:Delete()
    end
end