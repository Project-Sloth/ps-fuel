local Translations = {
    notify = {
        ["no_money"] = "No tienes suficiente dinero",
        ["refuel_cancel"] = "Rellenado de combustible cancelado",
        ["jerrycan_full"] = "Este bidón de gasolina ya está lleno",
        ["jerrycan_empty"] = "Este bidón de gasolina está vacío",
        ["vehicle_full"] = "Este vehículo ya está lleno",
        ["already_full"] = "El bidón de gasolina ya está lleno",
    },
    info = {
        ["refuel_vehicle"] = "Rellenar vehículo",
        ["gas_station"] = "Estación de gasolina",
        ["total_can_cost"] = "El costo total va a ser: $%{value} incluyendo impuestos",
        ["total_refuel_cost"] = "El costo total de rellenar del bidón de gasolina será $%{value}",
        ["buy_jerry_can"] = "Comprar bidón de gasolina",
        ["refuel_jerry_can"] = "Rellenar bidón de gasolina",
        ["total_cost"] = "El costo total será de: $%{value} incluyendo impuestos",
        ["refuel_from_jerry_can"] = "Rellenar de bidón de gasolina",
        ["purchased_jerry_can"] = "Has comprado un bidón de gasolina por $%{value}",
    },
    error = {
        ["vehicle_already_full"] = "El vehículo ya está lleno",
        ["no_fuel_gas_can"] = "No hay gasolina en el bidón",
        ["not_enough_cash"] = "No tienes suficiente dinero",
    }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
