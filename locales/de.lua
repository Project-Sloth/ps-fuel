local Translations = {
    notify = {
        ["no_money"] = "Ich habe nicht genug Geld",
        ["refuel_cancel"] = "Tanken abgebrochen",
        ["jerrycan_full"] = "Dieser Kanister ist bereits voll",
        ["vehicle_full"] = "Dieses Fahrzeug ist bereits voll",
        ["already_full"] = "Gas Can is already full",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
