Config = {

    AceCrypto = 'BEST',

    Settings = {
        cmdName = 'rob',

        NeedsItem = 'lockpick', -- or = false to disable
        ProtectOnDutyPersonel = true,

        FrameWork = 'Auto',
        Inventory = 'Auto',
        Notification = 'OX',

        Mode = 'OnlyHandsUp', -- Modes: 'OnlyHandsUp', 'OnlyWhenDead', 'BOTH'
        lang = 'en'
    },

    NotiMessages = {
        ['en'] = {
            ['robbing_initiated'] = 'Robbing player..',
            ['robbing_canceled'] = 'Cancled Robbing player..',
        }
    },
    
    DiscordLogs = {
        logActions = false,
    },

    DebugMode = true
}