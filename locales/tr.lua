local Translations = {
    notify = {
        ["no_money"] = "Yeterli paranız bulunmuyor",
        ["refuel_cancel"] = "Yakıt Doldurma İptal Edildi",
        ["jerrycan_full"] = "Bu yakıt bidonu zaten tamamen dolu",
        ["jerrycan_empty"] = "Bu yakıt bidonu boş",
        ["vehicle_full"] = "Bu aracın yakıtı tamamen dolu",
        ["already_full"] = "Yakıt Tankı zaten tamamen dolu",
    },
    info = {
        ["refuel_vehicle"] = "Yakıt İkmali Yap",
        ["take_nozzle"] = "Yakıt Pompasını Al",
        ["return_nozzle"] = "Yakıt Pompasını Bırak",
        ["gas_station"] = "Yakıt İstasyonu",
        ["total_can_cost"] = "Vergiler dahil toplam tutar: $%{value}",
        ["total_refuel_cost"] = "Yakıt ikmalinin toplam tutarı $%{value}",
        ["buy_jerry_can"] = "Yakıt Bidonu Satın Al",
        ["refuel_jerry_can"] = "Yakıt Bidonunu Doldur",
        ["total_cost"] = "Vergiler dahil toplam tutar: $%{value}",
        ["refuel_from_jerry_can"] = "Yakıt bidonundan ikmal yap",
        ["purchased_jerry_can"] = "Yakıt bidonunu $%{value} tutarından satın aldınız",
    },
    error = {
        ["vehicle_already_full"] = "Araç zaten dolu",
        ["no_fuel_gas_can"] = "Yakıt pompasında yakıt yok",
        ["not_enough_cash"] = "Yeterli nakitiniz yok",
    }
}

if GetConvar('qb_locale', 'en') == 'tr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
