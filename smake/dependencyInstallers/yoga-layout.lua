function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/facebook/yoga/archive/refs/tags/v2.0.0.zip')
        folder:RunIn('cmake . && make')
        folder:MoveHeaders('yoga', 'yoga')
        folder:MoveLibrary('yoga/libyogacore.a')
        folder:Delete()
    end
end
