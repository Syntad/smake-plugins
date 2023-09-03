function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/fmtlib/fmt/releases/download/10.1.0/fmt-10.1.0.zip')
        folder:RunIn('cmake -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE . && make fmt')
        folder:MoveIncludeFolder()
        folder:MoveLibraryFile('libfmt.a')
        folder:Delete()
    end
end