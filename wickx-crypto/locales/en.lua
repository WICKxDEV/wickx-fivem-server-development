local Translations = {
    error = {
        you_dont_have_a_cryptostick = 'You don\'t have a cryptostick',
        cryptostick_malfunctioned = 'Cryptostick malfunctioned'
    },
    success = {
        you_have_exchanged_your_cryptostick_for = 'You have exchanged your Cryptostick for: %{amount} WKXBit(s)'
    },
    credit = {
        there_are_amount_credited = 'You have been credited %{amount} WKXBit(s)!',
        you_have_wickxbit_purchased = 'You have purchased %{dataCoins} WKXBit(s)!'
    },
    debit = {
        you_have_sold = 'You have sold %{dataCoins} WKXBit(s)!'
    },
    text = {
        enter_usb = '[E] - Enter USB',
        system_is_rebooting = 'System is rebooting - %{rebootInfoPercentage} %',
        you_have_not_given_a_new_value = 'You have not given a new value ... Current value: %{crypto}',
        this_crypto_does_not_exist = 'This crypto does not exist, available crypto(s): WKXBit',
        you_have_not_provided_crypto_available_wickxbit = 'You have not provided Crypto, available: WKXBit',
        the_wickxbit_has_a_value_of = 'WKXBit has a value of: %{crypto}',
        you_have_with_a_value_of = 'You have %{playerPlayerDataMoneyCrypto} WKXBit(s) with a value of: %{mypocket},-'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
