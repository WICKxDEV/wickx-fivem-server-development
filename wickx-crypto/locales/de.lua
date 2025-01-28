local Translations = {
    error = {
        you_dont_have_a_cryptostick = 'Du hast keinen Cryptostick',
        cryptostick_malfunctioned = 'Cryptostick hat eine Fehlfunktion'
    },
    success = {
        you_have_exchanged_your_cryptostick_for = 'Du hast deinen Cryptostick eingetauscht gegen: %{amount} WKXBit(s)'
    },
    credit = {
        there_are_amount_credited = 'Dir wurden %{amount} WKXBit(s) gutgeschrieben!',
        you_have_wickxbit_purchased = 'Du hast %{dataCoins} WKXBit(s) gekauft!'
    },
    debit = {
        you_have_sold = 'Du hast %{dataCoins} WKXBit(s) verkauft!'
    },
    text = {
        enter_usb = '[E] - USB einstecken',
        system_is_rebooting = 'System wird neu gestartet - %{rebootInfoPercentage} %',
        you_have_not_given_a_new_value = 'Du hast keinen neuen Wert angegeben... Aktueller Wert: %{crypto}',
        this_crypto_does_not_exist = 'Diese Kryptowährung existiert nicht, verfügbare Kryptowährung(en): WKXBit',
        you_have_not_provided_crypto_available_wickxbit = 'Du hast keine Kryptowährung angegeben, verfügbar: WKXBit',
        the_wickxbit_has_a_value_of = 'WKXBit hat einen Wert von: %{crypto}',
        you_have_with_a_value_of = 'Du hast %{playerPlayerDataMoneyCrypto} WKXBit(s) mit einem Wert von: %{mypocket},-'
    }
}

if GetConvar('wickx_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
