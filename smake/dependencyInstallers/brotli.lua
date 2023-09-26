function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/google/brotli/archive/refs/heads/master.zip')
        folder:RunIn('cmake . -DBUILD_SHARED_LIBS=OFF && make')

        folder:MoveLibraries()
        folder:MoveIncludeFolder('c/include')

        folder:Delete()
    end
end