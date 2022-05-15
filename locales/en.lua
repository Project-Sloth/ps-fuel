local Translations = {
    notify = {
        ["no_money"] = "Don't not have enough money",
        ["refuel_cancel"] = "Refueling Canceled",
        ["jerrycan_full"] = "This jerry can is already full",
        ["jerrycan_empty"] = "This jerry can is empty",
        ["vehicle_full"] = "This vehicle is already full",
        ["already_full"] = "Gas Can is already full",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
