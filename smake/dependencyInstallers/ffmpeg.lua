function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/FFmpeg/FFmpeg/archive/refs/heads/master.zip')
        folder:RunIn('sh configure && make')

        folder:Move('*/*.a', installer:MakeLibraryFolder())

        folder:RunIn('find . -type f ! -name "*.h" -delete')
        folder:RunIn('find . -type d -empty -delete')
        folder:Move('*', installer:MakeIncludeFolder())

        folder:Delete()
    end
end