local Translations = {
    notify = {
        ["no_money"] = "Nemáš dostatek peněz",
        ["refuel_cancel"] = "Tankování zrušeno",
        ["jerrycan_full"] = "Tento kanystr je již plný",
        ["jerrycan_empty"] = "Tento kanystr je prázdný",
        ["vehicle_full"] = "Toto vozidlo je již plné",
        ["already_full"] = "Kanystr s benzínem je již plný",
    },
    info = {
        ["refuel_vehicle"] = "Doplnění paliva do vozidla",
        ["take_nozzle"] = "Vezměte si tankovací hadici",
        ["return_nozzle"] = "Vrátit tankovací hadici",
        ["gas_station"] = "Benzínová stanice",
        ["total_can_cost"] = "Celková cena bude: $%{value} včetně daní",
        ["total_refuel_cost"] = "Celkové náklady na doplnění benzínu do kanystru budou činit $%{value}",
        ["buy_jerry_can"] = "Koupit kanystr",
        ["refuel_jerry_can"] = "Doplnit palivo do kanystru",
        ["total_cost"] = "Celková cena bude: $%{value} včetně daní",
        ["refuel_from_jerry_can"] = "Tankování z kanystru",
        ["purchased_jerry_can"] = "Koupili jste kanystr za $%{value}",
    },
    error = {
        ["vehicle_already_full"] = "Vozidlo je již plné",
        ["no_fuel_gas_can"] = "Žádné palivo v kanystru",
        ["not_enough_cash"] = "Nemáte dostatek hotovosti",
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end