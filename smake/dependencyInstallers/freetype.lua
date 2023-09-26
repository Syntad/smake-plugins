function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        -- Run 2 passes, one without harfbuzz to build harfbuzz, and one after building harfbuzz
        local folder = installer:GitClone('https://github.com/freetype/freetype')
        folder:RunIn('sh autogen.sh && sh configure --without-harfbuzz')
        folder:RunIn('make')

        InstallDependencies('harfbuzz', 'libpng', 'brotli', 'zlib')

        folder:RunIn('sh configure')
        folder:RunIn('make')

        folder:MoveIncludeFolder()
        folder:MoveLibrary('objs/.libs/libfreetype.a')

        folder:Delete()
    end
end