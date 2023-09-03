function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/Tencent/rapidjson/archive/refs/heads/master.zip')
        folder:MoveIncludeFolder()
        folder:Delete()
    end
end