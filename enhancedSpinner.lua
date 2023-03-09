local enhancedSpinner = {}
local spinner = smake.spinner

-- Presets from https://github.com/sindresorhus/cli-spinners
local presets = {
    dots = {
        interval = 80,
        frames = {
            "⠋",
            "⠙",
            "⠹",
            "⠸",
            "⠼",
            "⠴",
            "⠦",
            "⠧",
            "⠇",
            "⠏"
        }
    },
    dots2 = {
        interval = 80,
        frames = {
            "⣾",
            "⣽",
            "⣻",
            "⢿",
            "⡿",
            "⣟",
            "⣯",
            "⣷"
        }
    },
    dots3 = {
        interval = 80,
        frames = {
            "⠋",
            "⠙",
            "⠚",
            "⠞",
            "⠖",
            "⠦",
            "⠴",
            "⠲",
            "⠳",
            "⠓"
        }
    },
    dots4 = {
        interval = 80,
        frames = {
            "⠄",
            "⠆",
            "⠇",
            "⠋",
            "⠙",
            "⠸",
            "⠰",
            "⠠",
            "⠰",
            "⠸",
            "⠙",
            "⠋",
            "⠇",
            "⠆"
        }
    },
    dots5 = {
        interval = 80,
        frames = {
            "⠋",
            "⠙",
            "⠚",
            "⠒",
            "⠂",
            "⠂",
            "⠒",
            "⠲",
            "⠴",
            "⠦",
            "⠖",
            "⠒",
            "⠐",
            "⠐",
            "⠒",
            "⠓",
            "⠋"
        }
    },
    dots6 = {
        interval = 80,
        frames = {
            "⠁",
            "⠉",
            "⠙",
            "⠚",
            "⠒",
            "⠂",
            "⠂",
            "⠒",
            "⠲",
            "⠴",
            "⠤",
            "⠄",
            "⠄",
            "⠤",
            "⠴",
            "⠲",
            "⠒",
            "⠂",
            "⠂",
            "⠒",
            "⠚",
            "⠙",
            "⠉",
            "⠁"
        }
    },
    dots7 = {
        interval = 80,
        frames = {
            "⠈",
            "⠉",
            "⠋",
            "⠓",
            "⠒",
            "⠐",
            "⠐",
            "⠒",
            "⠖",
            "⠦",
            "⠤",
            "⠠",
            "⠠",
            "⠤",
            "⠦",
            "⠖",
            "⠒",
            "⠐",
            "⠐",
            "⠒",
            "⠓",
            "⠋",
            "⠉",
            "⠈"
        }
    },
    dots8 = {
        interval = 80,
        frames = {
            "⠁",
            "⠁",
            "⠉",
            "⠙",
            "⠚",
            "⠒",
            "⠂",
            "⠂",
            "⠒",
            "⠲",
            "⠴",
            "⠤",
            "⠄",
            "⠄",
            "⠤",
            "⠠",
            "⠠",
            "⠤",
            "⠦",
            "⠖",
            "⠒",
            "⠐",
            "⠐",
            "⠒",
            "⠓",
            "⠋",
            "⠉",
            "⠈",
            "⠈"
        }
    },
    dots9 = {
        interval = 80,
        frames = {
            "⢹",
            "⢺",
            "⢼",
            "⣸",
            "⣇",
            "⡧",
            "⡗",
            "⡏"
        }
    },
    dots10 = {
        interval = 80,
        frames = {
            "⢄",
            "⢂",
            "⢁",
            "⡁",
            "⡈",
            "⡐",
            "⡠"
        }
    },
    dots11 = {
        interval = 100,
        frames = {
            "⠁",
            "⠂",
            "⠄",
            "⡀",
            "⢀",
            "⠠",
            "⠐",
            "⠈"
        }
    },
    dots12 = {
        interval = 80,
        frames = {
            "⢀⠀",
            "⡀⠀",
            "⠄⠀",
            "⢂⠀",
            "⡂⠀",
            "⠅⠀",
            "⢃⠀",
            "⡃⠀",
            "⠍⠀",
            "⢋⠀",
            "⡋⠀",
            "⠍⠁",
            "⢋⠁",
            "⡋⠁",
            "⠍⠉",
            "⠋⠉",
            "⠋⠉",
            "⠉⠙",
            "⠉⠙",
            "⠉⠩",
            "⠈⢙",
            "⠈⡙",
            "⢈⠩",
            "⡀⢙",
            "⠄⡙",
            "⢂⠩",
            "⡂⢘",
            "⠅⡘",
            "⢃⠨",
            "⡃⢐",
            "⠍⡐",
            "⢋⠠",
            "⡋⢀",
            "⠍⡁",
            "⢋⠁",
            "⡋⠁",
            "⠍⠉",
            "⠋⠉",
            "⠋⠉",
            "⠉⠙",
            "⠉⠙",
            "⠉⠩",
            "⠈⢙",
            "⠈⡙",
            "⠈⠩",
            "⠀⢙",
            "⠀⡙",
            "⠀⠩",
            "⠀⢘",
            "⠀⡘",
            "⠀⠨",
            "⠀⢐",
            "⠀⡐",
            "⠀⠠",
            "⠀⢀",
            "⠀⡀"
        }
    },
    dots13 = {
        interval = 80,
        frames = {
            "⣼",
            "⣹",
            "⢻",
            "⠿",
            "⡟",
            "⣏",
            "⣧",
            "⣶"
        }
    },
    dots8Bit = {
        interval = 80,
        frames = {
            "⠀",
            "⠁",
            "⠂",
            "⠃",
            "⠄",
            "⠅",
            "⠆",
            "⠇",
            "⡀",
            "⡁",
            "⡂",
            "⡃",
            "⡄",
            "⡅",
            "⡆",
            "⡇",
            "⠈",
            "⠉",
            "⠊",
            "⠋",
            "⠌",
            "⠍",
            "⠎",
            "⠏",
            "⡈",
            "⡉",
            "⡊",
            "⡋",
            "⡌",
            "⡍",
            "⡎",
            "⡏",
            "⠐",
            "⠑",
            "⠒",
            "⠓",
            "⠔",
            "⠕",
            "⠖",
            "⠗",
            "⡐",
            "⡑",
            "⡒",
            "⡓",
            "⡔",
            "⡕",
            "⡖",
            "⡗",
            "⠘",
            "⠙",
            "⠚",
            "⠛",
            "⠜",
            "⠝",
            "⠞",
            "⠟",
            "⡘",
            "⡙",
            "⡚",
            "⡛",
            "⡜",
            "⡝",
            "⡞",
            "⡟",
            "⠠",
            "⠡",
            "⠢",
            "⠣",
            "⠤",
            "⠥",
            "⠦",
            "⠧",
            "⡠",
            "⡡",
            "⡢",
            "⡣",
            "⡤",
            "⡥",
            "⡦",
            "⡧",
            "⠨",
            "⠩",
            "⠪",
            "⠫",
            "⠬",
            "⠭",
            "⠮",
            "⠯",
            "⡨",
            "⡩",
            "⡪",
            "⡫",
            "⡬",
            "⡭",
            "⡮",
            "⡯",
            "⠰",
            "⠱",
            "⠲",
            "⠳",
            "⠴",
            "⠵",
            "⠶",
            "⠷",
            "⡰",
            "⡱",
            "⡲",
            "⡳",
            "⡴",
            "⡵",
            "⡶",
            "⡷",
            "⠸",
            "⠹",
            "⠺",
            "⠻",
            "⠼",
            "⠽",
            "⠾",
            "⠿",
            "⡸",
            "⡹",
            "⡺",
            "⡻",
            "⡼",
            "⡽",
            "⡾",
            "⡿",
            "⢀",
            "⢁",
            "⢂",
            "⢃",
            "⢄",
            "⢅",
            "⢆",
            "⢇",
            "⣀",
            "⣁",
            "⣂",
            "⣃",
            "⣄",
            "⣅",
            "⣆",
            "⣇",
            "⢈",
            "⢉",
            "⢊",
            "⢋",
            "⢌",
            "⢍",
            "⢎",
            "⢏",
            "⣈",
            "⣉",
            "⣊",
            "⣋",
            "⣌",
            "⣍",
            "⣎",
            "⣏",
            "⢐",
            "⢑",
            "⢒",
            "⢓",
            "⢔",
            "⢕",
            "⢖",
            "⢗",
            "⣐",
            "⣑",
            "⣒",
            "⣓",
            "⣔",
            "⣕",
            "⣖",
            "⣗",
            "⢘",
            "⢙",
            "⢚",
            "⢛",
            "⢜",
            "⢝",
            "⢞",
            "⢟",
            "⣘",
            "⣙",
            "⣚",
            "⣛",
            "⣜",
            "⣝",
            "⣞",
            "⣟",
            "⢠",
            "⢡",
            "⢢",
            "⢣",
            "⢤",
            "⢥",
            "⢦",
            "⢧",
            "⣠",
            "⣡",
            "⣢",
            "⣣",
            "⣤",
            "⣥",
            "⣦",
            "⣧",
            "⢨",
            "⢩",
            "⢪",
            "⢫",
            "⢬",
            "⢭",
            "⢮",
            "⢯",
            "⣨",
            "⣩",
            "⣪",
            "⣫",
            "⣬",
            "⣭",
            "⣮",
            "⣯",
            "⢰",
            "⢱",
            "⢲",
            "⢳",
            "⢴",
            "⢵",
            "⢶",
            "⢷",
            "⣰",
            "⣱",
            "⣲",
            "⣳",
            "⣴",
            "⣵",
            "⣶",
            "⣷",
            "⢸",
            "⢹",
            "⢺",
            "⢻",
            "⢼",
            "⢽",
            "⢾",
            "⢿",
            "⣸",
            "⣹",
            "⣺",
            "⣻",
            "⣼",
            "⣽",
            "⣾",
            "⣿"
        }
    },
    sand = {
        interval = 80,
        frames = {
            "⠁",
            "⠂",
            "⠄",
            "⡀",
            "⡈",
            "⡐",
            "⡠",
            "⣀",
            "⣁",
            "⣂",
            "⣄",
            "⣌",
            "⣔",
            "⣤",
            "⣥",
            "⣦",
            "⣮",
            "⣶",
            "⣷",
            "⣿",
            "⡿",
            "⠿",
            "⢟",
            "⠟",
            "⡛",
            "⠛",
            "⠫",
            "⢋",
            "⠋",
            "⠍",
            "⡉",
            "⠉",
            "⠑",
            "⠡",
            "⢁"
        }
    },
    line = {
        interval = 130,
        frames = {
            "-",
            "\\",
            "|",
            "/"
        }
    },
    line2 = {
        interval = 100,
        frames = {
            "⠂",
            "-",
            "–",
            "—",
            "–",
            "-"
        }
    },
    pipe = {
        interval = 100,
        frames = {
            "┤",
            "┘",
            "┴",
            "└",
            "├",
            "┌",
            "┬",
            "┐"
        }
    },
    simpleDots = {
        interval = 400,
        frames = {
            ".  ",
            "..",
            "...",
            "   "
        }
    },
    simpleDotsScrolling = {
        interval = 200,
        frames = {
            ".  ",
            "..",
            "...",
            " ..",
            "  .",
            "   "
        }
    },
    star = {
        interval = 70,
        frames = {
            "✶",
            "✸",
            "✹",
            "✺",
            "✹",
            "✷"
        }
    },
    star2 = {
        interval = 80,
        frames = {
            "+",
            "x",
            "*"
        }
    },
    flip = {
        interval = 70,
        frames = {
            "_",
            "_",
            "_",
            "-",
            "`",
            "`",
            "'",
            "´",
            "-",
            "_",
            "_",
            "_"
        }
    },
    hamburger = {
        interval = 100,
        frames = {
            "☱",
            "☲",
            "☴"
        }
    },
    growVertical = {
        interval = 120,
        frames = {
            "▁",
            "▃",
            "▄",
            "▅",
            "▆",
            "▇",
            "▆",
            "▅",
            "▄",
            "▃"
        }
    },
    growHorizontal = {
        interval = 120,
        frames = {
            "▏",
            "▎",
            "▍",
            "▌",
            "▋",
            "▊",
            "▉",
            "▊",
            "▋",
            "▌",
            "▍",
            "▎"
        }
    },
    balloon = {
        interval = 140,
        frames = {
            "",
            ".",
            "o",
            "O",
            "@",
            "*",
            ""
        }
    },
    balloon2 = {
        interval = 120,
        frames = {
            ".",
            "o",
            "O",
            "°",
            "O",
            "o",
            "."
        }
    },
    noise = {
        interval = 100,
        frames = {
            "▓",
            "▒",
            "░"
        }
    },
    bounce = {
        interval = 120,
        frames = {
            "⠁",
            "⠂",
            "⠄",
            "⠂"
        }
    },
    boxBounce = {
        interval = 120,
        frames = {
            "▖",
            "▘",
            "▝",
            "▗"
        }
    },
    boxBounce2 = {
        interval = 100,
        frames = {
            "▌",
            "▀",
            "▐",
            "▄"
        }
    },
    triangle = {
        interval = 50,
        frames = {
            "◢",
            "◣",
            "◤",
            "◥"
        }
    },
    arc = {
        interval = 100,
        frames = {
            "◜",
            "◠",
            "◝",
            "◞",
            "◡",
            "◟"
        }
    },
    circle = {
        interval = 120,
        frames = {
            "◡",
            "⊙",
            "◠"
        }
    },
    squareCorners = {
        interval = 180,
        frames = {
            "◰",
            "◳",
            "◲",
            "◱"
        }
    },
    circleQuarters = {
        interval = 120,
        frames = {
            "◴",
            "◷",
            "◶",
            "◵"
        }
    },
    circleHalves = {
        interval = 50,
        frames = {
            "◐",
            "◓",
            "◑",
            "◒"
        }
    },
    squish = {
        interval = 100,
        frames = {
            "╫",
            "╪"
        }
    },
    toggle = {
        interval = 250,
        frames = {
            "⊶",
            "⊷"
        }
    },
    toggle2 = {
        interval = 80,
        frames = {
            "▫",
            "▪"
        }
    },
    toggle3 = {
        interval = 120,
        frames = {
            "□",
            "■"
        }
    },
    toggle4 = {
        interval = 100,
        frames = {
            "■",
            "□",
            "▪",
            "▫"
        }
    },
    toggle5 = {
        interval = 100,
        frames = {
            "▮",
            "▯"
        }
    },
    toggle6 = {
        interval = 300,
        frames = {
            "ဝ",
            "၀"
        }
    },
    toggle7 = {
        interval = 80,
        frames = {
            "⦾",
            "⦿"
        }
    },
    toggle8 = {
        interval = 100,
        frames = {
            "◍",
            "◌"
        }
    },
    toggle9 = {
        interval = 100,
        frames = {
            "◉",
            "◎"
        }
    },
    toggle10 = {
        interval = 100,
        frames = {
            "㊂",
            "㊀",
            "㊁"
        }
    },
    toggle11 = {
        interval = 50,
        frames = {
            "⧇",
            "⧆"
        }
    },
    toggle12 = {
        interval = 120,
        frames = {
            "☗",
            "☖"
        }
    },
    toggle13 = {
        interval = 80,
        frames = {
            "=",
            "*",
            "-"
        }
    },
    arrow = {
        interval = 100,
        frames = {
            "←",
            "↖",
            "↑",
            "↗",
            "→",
            "↘",
            "↓",
            "↙"
        }
    },
    arrow2 = {
        interval = 80,
        frames = {
            "⬆️",
            "↗️",
            "➡️",
            "↘️",
            "⬇️",
            "↙️",
            "⬅️",
            "↖️"
        }
    },
    arrow3 = {
        interval = 120,
        frames = {
            "▹▹▹▹▹",
            "▸▹▹▹▹",
            "▹▸▹▹▹",
            "▹▹▸▹▹",
            "▹▹▹▸▹",
            "▹▹▹▹▸"
        }
    },
    bouncingBar = {
        interval = 80,
        frames = {
            "[    ]",
            "[=   ]",
            "[==  ]",
            "[=== ]",
            "[ ===]",
            "[  ==]",
            "[   =]",
            "[    ]",
            "[   =]",
            "[  ==]",
            "[ ===]",
            "[====]",
            "[=== ]",
            "[==  ]",
            "[=   ]"
        }
    },
    bouncingBall = {
        interval = 80,
        frames = {
            "( ●    )",
            "(  ●   )",
            "(   ●  )",
            "(    ● )",
            "(     ●)",
            "(    ● )",
            "(   ●  )",
            "(  ●   )",
            "( ●    )",
            "(●     )"
        }
    },
    smiley = {
        interval = 200,
        frames = {
            "😄",
            "😝"
        }
    },
    monkey = {
        interval = 300,
        frames = {
            "🙈",
            "🙈",
            "🙉",
            "🙊"
        }
    },
    hearts = {
        interval = 100,
        frames = {
            "💛",
            "💙",
            "💜",
            "💚",
            "❤️"
        }
    },
    clock = {
        interval = 100,
        frames = {
            "🕛",
            "🕐",
            "🕑",
            "🕒",
            "🕓",
            "🕔",
            "🕕",
            "🕖",
            "🕗",
            "🕘",
            "🕙",
            "🕚"
        }
    },
    earth = {
        interval = 180,
        frames = {
            "🌍",
            "🌎",
            "🌏"
        }
    },
    material = {
        interval = 17,
        frames = {
            "█▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "██▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "███▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "████▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "██████▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "██████▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "███████▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "████████▁▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "██████████▁▁▁▁▁▁▁▁▁▁",
            "███████████▁▁▁▁▁▁▁▁▁",
            "█████████████▁▁▁▁▁▁▁",
            "██████████████▁▁▁▁▁▁",
            "██████████████▁▁▁▁▁▁",
            "▁██████████████▁▁▁▁▁",
            "▁██████████████▁▁▁▁▁",
            "▁██████████████▁▁▁▁▁",
            "▁▁██████████████▁▁▁▁",
            "▁▁▁██████████████▁▁▁",
            "▁▁▁▁█████████████▁▁▁",
            "▁▁▁▁██████████████▁▁",
            "▁▁▁▁██████████████▁▁",
            "▁▁▁▁▁██████████████▁",
            "▁▁▁▁▁██████████████▁",
            "▁▁▁▁▁██████████████▁",
            "▁▁▁▁▁▁██████████████",
            "▁▁▁▁▁▁██████████████",
            "▁▁▁▁▁▁▁█████████████",
            "▁▁▁▁▁▁▁█████████████",
            "▁▁▁▁▁▁▁▁████████████",
            "▁▁▁▁▁▁▁▁████████████",
            "▁▁▁▁▁▁▁▁▁███████████",
            "▁▁▁▁▁▁▁▁▁███████████",
            "▁▁▁▁▁▁▁▁▁▁██████████",
            "▁▁▁▁▁▁▁▁▁▁██████████",
            "▁▁▁▁▁▁▁▁▁▁▁▁████████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁███████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁██████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█████",
            "█▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁████",
            "██▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁███",
            "██▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁███",
            "███▁▁▁▁▁▁▁▁▁▁▁▁▁▁███",
            "████▁▁▁▁▁▁▁▁▁▁▁▁▁▁██",
            "█████▁▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "█████▁▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "██████▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "████████▁▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "█████████▁▁▁▁▁▁▁▁▁▁▁",
            "███████████▁▁▁▁▁▁▁▁▁",
            "████████████▁▁▁▁▁▁▁▁",
            "████████████▁▁▁▁▁▁▁▁",
            "██████████████▁▁▁▁▁▁",
            "██████████████▁▁▁▁▁▁",
            "▁██████████████▁▁▁▁▁",
            "▁██████████████▁▁▁▁▁",
            "▁▁▁█████████████▁▁▁▁",
            "▁▁▁▁▁████████████▁▁▁",
            "▁▁▁▁▁████████████▁▁▁",
            "▁▁▁▁▁▁███████████▁▁▁",
            "▁▁▁▁▁▁▁▁█████████▁▁▁",
            "▁▁▁▁▁▁▁▁█████████▁▁▁",
            "▁▁▁▁▁▁▁▁▁█████████▁▁",
            "▁▁▁▁▁▁▁▁▁█████████▁▁",
            "▁▁▁▁▁▁▁▁▁▁█████████▁",
            "▁▁▁▁▁▁▁▁▁▁▁████████▁",
            "▁▁▁▁▁▁▁▁▁▁▁████████▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁███████▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁███████▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁███████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁███████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁████",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁███",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁███",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁██",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁██",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁██",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁",
            "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
        }
    },
    moon = {
        interval = 80,
        frames = {
            "🌑",
            "🌒",
            "🌓",
            "🌔",
            "🌕",
            "🌖",
            "🌗",
            "🌘"
        }
    },
    runner = {
        interval = 140,
        frames = {
            "🚶",
            "🏃"
        }
    },
    pong = {
        interval = 80,
        frames = {
            "▐⠂       ▌",
            "▐⠈       ▌",
            "▐ ⠂      ▌",
            "▐ ⠠      ▌",
            "▐  ⡀     ▌",
            "▐  ⠠     ▌",
            "▐   ⠂    ▌",
            "▐   ⠈    ▌",
            "▐    ⠂   ▌",
            "▐    ⠠   ▌",
            "▐     ⡀  ▌",
            "▐     ⠠  ▌",
            "▐      ⠂ ▌",
            "▐      ⠈ ▌",
            "▐       ⠂▌",
            "▐       ⠠▌",
            "▐       ⡀▌",
            "▐      ⠠ ▌",
            "▐      ⠂ ▌",
            "▐     ⠈  ▌",
            "▐     ⠂  ▌",
            "▐    ⠠   ▌",
            "▐    ⡀   ▌",
            "▐   ⠠    ▌",
            "▐   ⠂    ▌",
            "▐  ⠈     ▌",
            "▐  ⠂     ▌",
            "▐ ⠠      ▌",
            "▐ ⡀      ▌",
            "▐⠠       ▌"
        }
    },
    shark = {
        interval = 120,
        frames = {
            "▐|\\____________▌",
            "▐_|\\___________▌",
            "▐__|\\__________▌",
            "▐___|\\_________▌",
            "▐____|\\________▌",
            "▐_____|\\_______▌",
            "▐______|\\______▌",
            "▐_______|\\_____▌",
            "▐________|\\____▌",
            "▐_________|\\___▌",
            "▐__________|\\__▌",
            "▐___________|\\_▌",
            "▐____________|\\▌",
            "▐____________/|▌",
            "▐___________/|_▌",
            "▐__________/|__▌",
            "▐_________/|___▌",
            "▐________/|____▌",
            "▐_______/|_____▌",
            "▐______/|______▌",
            "▐_____/|_______▌",
            "▐____/|________▌",
            "▐___/|_________▌",
            "▐__/|__________▌",
            "▐_/|___________▌",
            "▐/|____________▌"
        }
    },
    dqpb = {
        interval = 100,
        frames = {
            "d",
            "q",
            "p",
            "b"
        }
    },
    weather = {
        interval = 100,
        frames = {
            "☀️",
            "☀️",
            "☀️",
            "🌤",
            "⛅️",
            "🌥",
            "☁️",
            "🌧",
            "🌨",
            "🌧",
            "🌨",
            "🌧",
            "🌨",
            "⛈",
            "🌨",
            "🌧",
            "🌨",
            "☁️",
            "🌥",
            "⛅️",
            "🌤",
            "☀️",
            "☀️"
        }
    },
    christmas = {
        interval = 400,
        frames = {
            "🌲",
            "🎄"
        }
    },
    grenade = {
        interval = 80,
        frames = {
            "،  ",
            "′  ",
            " ´",
            " ‾",
            "  ⸌",
            "  ⸊",
            "  |",
            "  ⁎",
            "  ⁕",
            " ෴",
            "  ⁓",
            "   ",
            "   ",
            "   "
        }
    },
    point = {
        interval = 125,
        frames = {
            "∙∙∙",
            "●∙∙",
            "∙●∙",
            "∙∙●",
            "∙∙∙"
        }
    },
    layer = {
        interval = 150,
        frames = {
            "-",
            "=",
            "≡"
        }
    },
    betaWave = {
        interval = 80,
        frames = {
            "ρββββββ",
            "βρβββββ",
            "ββρββββ",
            "βββρβββ",
            "ββββρββ",
            "βββββρβ",
            "ββββββρ"
        }
    },
    fingerDance = {
        interval = 160,
        frames = {
            "🤘",
            "🤟",
            "🖖",
            "✋",
            "🤚",
            "👆"
        }
    },
    soccerHeader = {
        interval = 80,
        frames = {
            " 🧑⚽️       🧑",
            "🧑  ⚽️      🧑",
            "🧑   ⚽️     🧑",
            "🧑    ⚽️    🧑",
            "🧑     ⚽️   🧑",
            "🧑      ⚽️  🧑",
            "🧑       ⚽️🧑  ",
            "🧑      ⚽️  🧑",
            "🧑     ⚽️   🧑",
            "🧑    ⚽️    🧑",
            "🧑   ⚽️     🧑",
            "🧑  ⚽️      🧑"
        }
    },
    mindblown = {
        interval = 160,
        frames = {
            "😐",
            "😐",
            "😮",
            "😮",
            "😦",
            "😦",
            "😧",
            "😧",
            "🤯",
            "💥",
            "✨",
            utf8.char(3000),
            utf8.char(3000),
            utf8.char(3000)
        }
    },
    speaker = {
        interval = 160,
        frames = {
            "🔈",
            "🔉",
            "🔊",
            "🔉"
        }
    },
    orangePulse = {
        interval = 100,
        frames = {
            "🔸",
            "🔶",
            "🟠",
            "🟠",
            "🔶"
        }
    },
    bluePulse = {
        interval = 100,
        frames = {
            "🔹",
            "🔷",
            "🔵",
            "🔵",
            "🔷"
        }
    },
    orangeBluePulse = {
        interval = 100,
        frames = {
            "🔸",
            "🔶",
            "🟠",
            "🟠",
            "🔶",
            "🔹",
            "🔷",
            "🔵",
            "🔵",
            "🔷"
        }
    },
    timeTravel = {
        interval = 100,
        frames = {
            "🕛",
            "🕚",
            "🕙",
            "🕘",
            "🕗",
            "🕖",
            "🕕",
            "🕔",
            "🕓",
            "🕒",
            "🕑",
            "🕐"
        }
    },
    aesthetic = {
        interval = 80,
        frames = {
            "▰▱▱▱▱▱▱",
            "▰▰▱▱▱▱▱",
            "▰▰▰▱▱▱▱",
            "▰▰▰▰▱▱▱",
            "▰▰▰▰▰▱▱",
            "▰▰▰▰▰▰▱",
            "▰▰▰▰▰▰▰",
            "▰▱▱▱▱▱▱"
        }
    }
}

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

local function formatEndText(text)
    if not text then
        return
    end

    if enhancedSpinner.prefix then
        text = enhancedSpinner.prefix .. ' ' .. text
    end

    return text
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
        if name == 'symbols' and type(name) == 'string' then
            assert(presets[value], 'Spinner preset"' .. value .. '" does not exist')
            smake.spinner.interval = presets[value].interval
            value = presets[value].frames
        elseif name == 'prefix' then
            enhancedSpinner.prefix = value
        end

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

function enhancedSpinner.Call(func, startText, endText, ...)
    enhancedSpinner.Start(startText)
    func(...)
    enhancedSpinner.Stop(formatEndText(endText))
end

function Plugin.Import()
    return enhancedSpinner
end