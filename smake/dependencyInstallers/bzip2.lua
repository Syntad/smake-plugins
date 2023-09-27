function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/libarchive/bzip2/archive/refs/heads/master.zip')
        folder:RunIn('cmake -DENABLE_STATIC_LIB=ON -DENABLE_SHARED_LIB=OFF . && make')

        folder:MoveHeaders()
        folder:MoveLibrary('libbz2_static.a')
        folder:Delete()
    end
end