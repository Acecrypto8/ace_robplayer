Config = {

    AceCrypto = 'BEST',

    Settings = {
        cmdName = 'rob',

        NeedsItem = 'lockpick', -- or = false to disable
        ProtectOnDutyPersonel = true,
        ProtectedPersonel = {ems = true, police = true},

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
            ['robbing_success'] = 'Succesfully reached into players pocket!',
            ['robbing_while_dead'] = 'You cannot use this command while dead',
            ['onduty_personel_error'] = 'Cant rob a onduty personel',
            ['robbing_distrupted'] = 'Failed to rob player',
            ['robbing_canceled'] = 'Cancled Robbing player..',
            ['player_doesnt_have_handsup'] = 'Cant rob this player, he doesnt have his hands up',
            ['rob_only_dead_players'] = 'You can only rob dead players!'
        }
    },
    
    DiscordLogs = {
        logActions = false,
    },

    DebugMode = true
}