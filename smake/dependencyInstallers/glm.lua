function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/g-truc/glm/releases/download/0.9.9.8/glm-0.9.9.8.zip')
        folder:Move('glm', installer:MakeIncludeFolder() .. '/glm')
        folder:Delete()
    end
end