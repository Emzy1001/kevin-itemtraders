return {
    webhook = '', -- Discord webhook to send logs to
    night = {
        start = 1,
        ends = 4,
    },
    locations = {
        {
            type = 'Multi-Option Trader', -- used for the log
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
                    label = 'Trade Items',
                },
            },
            blip = {
                use = true,
                sprite = 402,
                color = 5,
                scale = 0.8,
                label = 'Item Trader',
            },
            tradeOptions = {
                -- New trade system: Each location can have multiple trade options
                -- Players can choose quantity and see different reward types
                {
                    id = 'sell_copper_cash',
                    type = 'sell', -- 'sell' for currency, 'exchange' for item
                    label = 'Sell Copper for Cash',
                    description = 'Exchange copper for money',
                    icon = 'fa-solid fa-dollar-sign',
                    requiredItem = 'copper',
                    reward = {
                        type = 'cash',
                        amount = 230
                    }
                },
                {
                    id = 'exchange_copper_lockpick',
                    type = 'exchange',
                    label = 'Exchange Copper for Lockpick',
                    description = 'Trade copper for lockpicks',
                    icon = 'fa-solid fa-key',
                    requiredItem = 'copper',
                    reward = {
                        type = 'item',
                        item = 'lockpick',
                        amount = 1
                    }
                }
            }
        },
    }
}