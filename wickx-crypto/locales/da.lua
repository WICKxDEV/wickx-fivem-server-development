local Translations = {
    error = {
        you_dont_have_a_cryptostick = 'Du har ikke en cryptostick',
        cryptostick_malfunctioned = 'Cryptostick defekt'
    },
    success = {
        you_have_exchanged_your_cryptostick_for = 'Du har byttet dit Cryptostick til: %{amount} WKXBit(s)'
    },
    credit = {
        there_are_amount_credited = 'Der er %{amount} WKXBit(s) krediteret!',
        you_have_wickxbit_purchased = 'Du har købt %{dataCoins} WKXBit(s)!'
    },
    depreciation = {
        you_have_sold = 'Du har %{dataCoins} WKXBit(s) solgt!'
    },
    text = {
        enter_usb = '[E] - Indtast USB',
        system_is_rebooting = 'Systemet genstarter - %{rebootInfoPercentage} %',
        you_have_not_given_a_new_value = 'Du har ikke givet en ny værdi .. Nuværende værdier: %{crypto}',
        this_crypto_does_not_exist = 'Denne krypto eksisterer ikke :(, tilgængelig: WKXBit',
        you_have_not_provided_crypto_available_wickxbit = 'Du har ikke leveret Krypto, tilgængelig: WKXBit',
        the_wickxbit_has_a_value_of = 'WKXBit\'en har en værdi på: %{crypto}',
        you_have_with_a_value_of = 'Du har: %{playerPlayerDataMoneyCrypto} WKXBit, med en værdi på: %{mypocket},-'
    }
}

if GetConvar('wickx_locale', 'en') == 'da' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
