function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUntar('https://github.com/openssl/openssl/releases/download/openssl-3.1.2/openssl-3.1.2.tar.gz')
        folder:RunIn('perl Configure && make')
        folder:MoveIncludeFolder()
        folder:MoveLibraries()
        folder:Delete()
    end
end