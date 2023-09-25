function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/glfw/glfw/archive/refs/heads/master.zip')
        folder:RunIn('cmake . && make')
        folder:MoveIncludeFolder()
        folder:MoveLibrary('src/libglfw3.a')
        folder:Delete()
    end
end