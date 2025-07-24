Config = {

    AceCrypto = 'BEST',

    Settings = {
        cmdName = 'rob',

        NeedsItem = 'lockpick', -- or = false to disable
        ProtectOnDutyPersonel = true,

        FrameWork = 'Auto',
        Inventory = 'Auto',
        Notification = 'OX',

        Mode = 'OnlyWhenHandsUp', -- Modes: 'OnlyWhenHandsUp', 'OnlyWhenDead', 'BOTH'
        lang = 'en'
    },

    NotiMessages = {
        ['en'] = {
            ['script_initiated'] = 'Script Started',
            ['robbing_initiated'] = 'Trying to Rob player..',
            ['robbing_while_dead'] = 'You cannot use this command while dead',
            ['robbing_distrupted'] = 'Cant Rob this player',
            ['robbing_canceled'] = 'Cancled Robbing player..',
        }
    },
    
    DiscordLogs = {
        logActions = false,
    },

    DebugMode = true
}