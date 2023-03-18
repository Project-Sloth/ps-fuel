local Translations = {
    notify = {
        ["no_money"] = "You don't have enough money",
        ["refuel_cancel"] = "Refueling Cancelled",
        ["jerrycan_full"] = "This jerry can is already full",
        ["jerrycan_empty"] = "This jerry can is empty",
        ["vehicle_full"] = "This vehicle is already full",
        ["already_full"] = "Gas Can is already full",
    },
    info = {
        ["refuel_vehicle"] = "Refuel Vehicle",
        ["take_nozzle"] = "Take Nozzle",
        ["return_nozzle"] = "Return Nozzle",
        ["gas_station"] = "Gas Station",
        ["total_can_cost"] = "The total cost is going to be: $%{value} including taxes",
        ["total_refuel_cost"] = "The total cost of refueling the gas can will be $%{value}",
        ["buy_jerry_can"] = "Buy Jerry Can",
        ["refuel_jerry_can"] = "Refuel Jerry Can",
        ["total_cost"] = "The total cost is going to be: $%{value} including taxes",
        ["refuel_from_jerry_can"] = "Refuel from jerry can",
        ["purchased_jerry_can"] = "You purchased a jerry can for $%{value}",
    },
    error = {
        ["vehicle_already_full"] = "Vehicle already full",
        ["no_fuel_gas_can"] = "No fuel in gas can",
        ["not_enough_cash"] = "You don't have enough cash",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
