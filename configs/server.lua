return {
    webhook = '', -- Discord webhook to send logs to
    night = {
        start = 1,
        ends = 4,
    },
    locations = {
        {
            type = 'Auto Parts Trader', -- used for the log
            reputation = {
                use = true, -- use reputation system
                name = 'mechanic', -- the name of the reputation system
                threshold = 0, -- the threshold to allow the player to interact with the ped
                reputationPayment = 100, -- the amount to reward the player for selling items
            },
            ped = {
                model = `s_m_m_autoshop_01`,
                coords = vector4(38.37, -1455.9, 29.31, 58.13),
                nightOnly = false, -- the ped only spawns at night
                scenario = 'WORLD_HUMAN_COP_IDLES',
                target = {
                    icon = 'fa-solid fa-hand-holding-dollar',
                    label = 'Sell Auto Parts',
                },
            },
            blip = {
                use = true,
                sprite = 402,
                color = 5,
                scale = 0.8,
                label = 'Auto Parts Trader',
            },
            items = {
                ['copper'] = 230,
                ['iron'] = 230,
                ['steel'] = 230,
                ['rubber'] = 160,
                ['lockpick'] = 230,
            }
        },
        {
            type = 'House Robbery Trader',
            reputation = {
                use = true,
                name = 'criminal',
                threshold = 100,
            },
            ped = {
                model = `s_m_y_dealer_01`,
                coords = vector4(-152.83, -1326.5, 32.3, 2.68),
                nightOnly = false,
                scenario = 'WORLD_HUMAN_AA_SMOKE',
                target = {
                    icon = 'fa-solid fa-house-chimney-window',
                    label = 'Sell House Items',
                },
            },
            blip = {
                use = false,
                sprite = 402,
                color = 5,
                scale = 0.8,
                label = 'House Robbery Trader',
            },
            items = {
                ['samsungphone'] = 140,
                ['rolex'] = 140,
                ['goldchain'] = 140,
                ['toaster'] = 140,
                ['microwave'] = 300,
            }
        },
    }
}