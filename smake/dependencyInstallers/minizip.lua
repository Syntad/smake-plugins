function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUnzip('https://github.com/zlib-ng/minizip-ng/archive/refs/heads/master.zip')
        folder:RunIn('cmake . -DMZ_DECOMPRESS_ONLY=ON -DMZ_FETCH_LIBS=ON -DMZ_FORCE_FETCH_LIBS=ON')
        folder:RunIn('make')

        local lib = installer:MakeLibraryFolder()
        folder:Move('*.h', installer:MakeIncludeFolder())

        -- Move libbzip2 and libminizip
        folder:Move('*.a', lib)

        -- Build and move zstd
        folder:RunIn('cd third_party/zstd && make')
        folder:Move('third_party/zstd/lib/libzstd.a', lib .. '/libzstd.a')

        -- Build and move liblzma
        folder:RunIn('cd third_party/liblzma && cmake . && make')
        folder:Move('third_party/liblzma/liblzma.a', lib .. '/liblzma.a')

        folder:Delete()
    end
end