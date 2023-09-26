function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:GitClone('https://github.com/Antfroze/swindow')
        folder:RunIn('smake')
        folder:MoveIncludeFolder(nil, 'swindow')
        folder:MoveLibrary('out/libswindow.a')
        folder:Delete()
    end
end
