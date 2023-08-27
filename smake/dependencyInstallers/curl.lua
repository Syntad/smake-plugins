local fs = import('smake/utils/fs')

function Plugin.Import()
    --- @type fun(installer: installer)
    return function(installer)
        InstallDependency('openssl')
        
        local folder = installer:DownloadAndUntar('https://github.com/curl/curl/releases/download/curl-8_2_1/curl-8.2.1.tar.gz')
        folder:RunIn('perl configure --with-openssl=$(realpath ../dependencies/openssl) && make')

        local includeFolder = fs.ConcatenatePaths(installer:MakeIncludeFolder(), 'curl')
        fs.CreateFolder(includeFolder)
        folder:Move('include/curl/*.h', includeFolder)

        if platform.is_linux then
            folder:RunIn('cp -L lib/.libs/libcurl.so ' .. '../' .. installer:MakeLibraryFolder())
        elseif platform.is_osx then
            folder:RunIn('cp -L lib/.libs/libcurl.dylib ' .. '../' .. installer:MakeLibraryFolder())
        elseif platform.is_windows then

        end

        folder:Delete()
    end
end