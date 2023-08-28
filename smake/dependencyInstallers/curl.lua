local fs = import('smake/utils/fs')

function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        local folder = installer:DownloadAndUntar('https://github.com/curl/curl/releases/download/curl-8_2_1/curl-8.2.1.tar.gz')
        folder:RunIn('perl configure --with-openssl=$(realpath ../dependencies/openssl)')

        if platform.is_windows then
            -- Apply libtool fix
            local file = io.open(fs.ConcatenatePaths(folder.path, 'libtool'), 'r+')

            if file then
                local patch = file:read('*all'):gsub('eval "$_G_cmd"', 'eval $(echo "$_G_cmd" | sed \'s/|\\s*|/|/g\')')
                file:seek('set')
                file:write(patch)
                file:close()
            else
                print('Could not apply Windows patch, attempting to build anyways')
            end
        end

        folder:RunIn('make')

        local includeFolder = fs.ConcatenatePaths(installer:MakeIncludeFolder(), 'curl')
        fs.CreateFolder(includeFolder)
        folder:Move('include/curl/*.h', includeFolder)

        local extension = 'so'

        if platform.is_osx then
            extension = 'dylib'
        elseif platform.is_windows then
            extension = 'dll.a'
        end

        folder:RunIn(('cp -L lib/.libs/libcurl.%s ../'):format(extension) .. installer:MakeLibraryFolder())

        folder:Delete()
    end
end