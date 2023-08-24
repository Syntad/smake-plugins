function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip("https://developer.apple.com/metal/cpp/files/metal-cpp_macOS13.3_iOS16.4.zip")
        local includeFolder = installer:MakeIncludeFolder();
        folder:Move("Metal", includeFolder)
        folder:Move("Foundation", includeFolder)
        folder:Move("QuartzCore", includeFolder)
        folder:Delete()
    end
end