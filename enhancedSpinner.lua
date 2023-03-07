local enhancedSpinner = {}
local spinner = smake.spinner

local colors = {
    none = 0,

    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,

    brightblack = 90,
    brightred = 91,
    brightgreen = 92,
    brightyellow = 93,
    brightblue = 94,
    brightmagenta = 95,
    brightcyan = 96,
    brightwhite = 97
}

local validColors = {}

for _, color in next, colors do
    validColors[color] = true
end

function enhancedSpinner.SetColor(color)
    if not spinner.symbols then
        return
    end

    if type(color) == 'string' then
        color = colors[color:lower()]
        assert(color, 'Invalid color provided to EnhancedSpinner.SetColor')
    end

    assert(validColors[color], 'Invalid color provided to EnhancedSpinner.SetColor')

    for i, frame in next, spinner.symbols do
        spinner.symbols[i] = '\27[' .. color .. 'm' .. frame .. '\27[0m'
    end

    return enhancedSpinner
end

function enhancedSpinner.SetOptions(options)
    for name, value in next, options do
        smake.spinner[name] = value
    end

    if options.color then
        enhancedSpinner.SetColor(options.color)
    end

    if options.text then
        enhancedSpinner.SetText(options.text)
    end

    return enhancedSpinner
end

function enhancedSpinner.SetText(text)
    smake.spinner.setText(text)

    return enhancedSpinner
end

function enhancedSpinner.Start(text)
    if text then
        enhancedSpinner.SetText(text)
    end

    smake.spinner.start()

    return enhancedSpinner
end

function enhancedSpinner.Stop(text)
    smake.spinner.stop()

    if text then
        print(text)
    end

    return enhancedSpinner
end

function Plugin.Import()
    return enhancedSpinner
end