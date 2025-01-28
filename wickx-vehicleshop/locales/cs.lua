local Translations = {
    error = {
        testdrive_alreadyin = "Uz jsi v testovaci jizde!",
        testdrive_return = "Toto neni vozidlo, ktere jsi testoval",
        Invalid_ID = "Spatne ID",
        playertoofar = "Hrac je moc daleko",
        notenoughmoney = "Nemas dostatek penez",
        minimumallowed = "Minimalni povolena vyse je CZK",
        overpaid = "Preplatil jsi",
        alreadypaid = "Vozidlo je uz zaplaceno",
        notworth = "Vozidlo nema takovou cenu",
        downtoosmall = "Down payment too small",
        exceededmax = "Prekrocil jsi maximalni castku",
        repossessed = "Tvoje registracni znacka %{plate} byla odebrana",
        buyerinfo = "Nemohl jsem zjistit info kupujiciho",
        notinveh = "Musis byt ve vozidle pokud ho chces prepsat",
        vehinfo = "Nemohl jsem zjistit info o vozidle",
        notown = "Nevlastnis toto vozidlo",
        buyertoopoor = "Kupujuci nema dostatek financi",
        nofinanced = "Nemas zadne vozidlo na splatky",
    },
    success = {
        purchased = "Gratulujeme k vyberu! At slouzi!",
        earned_commission = "Dostal jsi %{amount} CZK v komisnim prodeji",
        gifted = "Daroval jsi vozidlo",
        received_gift = "Dostal jsi dar v podobe vozidla",
        soldfor = "Prodal jsi vozidlo za CZK",
        boughtfor = "Koupil jsi vozidlo za CZK",
    },
    menus = {
        vehHeader_header = "Moznosti vozidla",
        vehHeader_txt = "Ovladej momentalni vozidlo",
        financed_header = "Vozidla na splatky",
        finance_txt = "Podivej se na vlastni vozidla na splatky",
        returnTestDrive_header = "Ukoncit testovaci jizdu",
        goback_header = "Jit zpet",
        veh_price = "Cena: CZK",
        veh_platetxt = "RZ: ",
        veh_finance = "Financovani vozidla",
        veh_finance_balance = "Celkova castka, ktera zbyva",
        veh_finance_currency = "CZK",
        veh_finance_total = "Celkova castka, ktera zbyva",
        veh_finance_reccuring = "Cekajici platba castka",
        veh_finance_pay = "Udelat platbu",
        veh_finance_payoff = "Vyplaceni vozidla",
        veh_finance_payment = "Castka k zaplaceni (CZK)",
        submit_text = "Potvrdit",
        test_header = "Testovaci jizda",
        finance_header = "Financovani vozidla",
        swap_header = "Vymenit vozidlo",
        swap_txt = "Podivej se na jine vozidla",
        financesubmit_downpayment = "Castka zalohy - Min ",
        financesubmit_totalpayment = "Celkova castka - Max ",
        --Free Use
        freeuse_test_txt = "Vyzkousej momentalne vybrane vozidlo!",
        freeuse_buy_header = "Koupit vozidlo",
        freeuse_buy_txt = "Koupit momentalne vybrane vozidlo",
        freeuse_finance_txt = "Financuj momentalne vybrane vozidlo",
        --Managed
        managed_test_txt = "Povolit hraci testovaci jizdu",
        managed_sell_header = "Prodej vozidlo",
        managed_sell_txt = "Prodej vozidlo hraci",
        managed_finance_txt = "Financovani vozidla",
        submit_ID = "Server ID (#)",
    },
    general = {
        testdrive_timer = "Kolik zbyva do konce testovaci jizdy:",
        vehinteraction = "Ovladej vozidlo",
        testdrive_timenoti = "Zbyva ti %{testdrivetime} minut",
        testdrive_complete = "Testovaci jizda ukoncena!",
        paymentduein = "Musis provest platbu vozidla do %{time} minut",
        command_transfervehicle = "Daruj nebo prodej vozidlo",
        command_transfervehicle_help = "ID kupujiciho",
        command_transfervehicle_amount = "Prodejni castka (Na tobe)",
    }
}

if GetConvar('wickx_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
