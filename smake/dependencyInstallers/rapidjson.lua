function Plugin.Import()
    return 'rapidjson',
    --- @type fun(installer: installer)
    function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/Tencent/rapidjson/archive/refs/heads/master.zip')
        folder:MoveInclude()
        folder:Delete()
    end
end