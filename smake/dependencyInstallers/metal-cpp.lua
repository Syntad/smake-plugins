function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:GitClone('https://github.com/Antfroze/metal-cpp')
        folder:MoveIncludeFolder()
        folder:Delete()
    end
end
