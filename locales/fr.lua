local Translations = {
    notify = {
        ["no_money"] = "Vous n'avez pas assez d'argent",
        ["refuel_cancel"] = "Ravitaillement annulé",
        ["jerrycan_full"] = "Ce jerrican est déjà plein",
        ["jerrycan_empty"] = "Ce jerrican est vide",
        ["vehicle_full"] = "Ce véhicule est déjà plein",
        ["already_full"] = "Le jerrican est déjà plein",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
