function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:GitClone('https://github.com/harfbuzz/harfbuzz')
        folder:RunIn('sh autogen.sh && sh configure --disable-shared')
        folder:RunIn('make')

        folder:MoveLibraries('src/.libs')
        folder:MoveHeaders('src')

        folder:Delete()
    end
end