local Translations = {
    notify = {
        ["no_money"] = "You don't have enough money",
        ["refuel_cancel"] = "Refueling Cancelled",
        ["jerrycan_full"] = "This jerry can is already full",
        ["jerrycan_empty"] = "This jerry can is empty",
        ["vehicle_full"] = "This vehicle is already full",
        ["already_full"] = "Gas Can is already full",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
