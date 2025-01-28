local Translations = {
    error = {
        testdrive_alreadyin = "Bereits in der Probefahrt",
        testdrive_return = "Dies ist kein Fahrzeug für eine Probefahrt",
        Invalid_ID = "Ungültige Bürger-ID angegeben",
        playertoofar = "Dieser Bürger ist nicht nah genug dran",
        notenoughmoney = "Nicht genug Geld",
        minimumallowed = "Die zulässige Mindestzahlung beträgt €",
        overpaid = "Du hast zu viel bezahlt",
        alreadypaid = "Das Fahrzeug ist bereits abbezahlt",
        notworth = "Das Fahrzeug ist nicht so viel wert",
        downtoosmall = "Anzahlung zu klein",
        exceededmax = "Der maximale Zahlungsbetrag wurde überschritten",
        repossessed = "Dein Fahrzeug mit dem Kennzeichen %{plate} wurde beschlagnahmt",
        buyerinfo = "Käuferinformationen konnten nicht abgerufen werden",
        notinveh = "Du musst im Fahrzeug sein, das du übertragen möchtest",
        vehinfo = "Fahrzeuginformationen konnten nicht abgerufen werden",
        notown = "Du besitzt dieses Fahrzeug nicht",
        buyertoopoor = "Der Käufer hat nicht genug Geld",
        nofinanced = "Du hast keine finanzierten Fahrzeuge an diesem Standort",
        financed = "Dieses Fahrzeug ist finanziert",
    },
    success = {
        purchased = "Glückwunsch zu deinem Kauf!",
        earned_commission = "Du hast € %{amount} an Provision verdient",
        gifted = "Du hast dein Fahrzeug verschenkt",
        received_gift = "Dir wurde ein Fahrzeug geschenkt",
        soldfor = "Du hast dein Fahrzeug für € verkauft",
        boughtfor = "Du hast ein Fahrzeug für € gekauft",
    },
    menus = {
        vehHeader_header = "Fahrzeugoptionen",
        vehHeader_txt = "Interagiere mit dem aktuellen Fahrzeug",
        financed_header = "Finanzierte Fahrzeuge",
        finance_txt = "Durchsuche deine Fahrzeuge",
        returnTestDrive_header = "Probefahrt beenden",
        goback_header = "Zurück",
        veh_price = "Preis: €",
        veh_platetxt = "Kennzeichen: ",
        veh_finance = "Fahrzeugfinanzierung",
        veh_finance_balance = "Restbetrag",
        veh_finance_currency = "€",
        veh_finance_total = "Verbleibende Zahlungen",
        veh_finance_reccuring = "Wiederkehrender Zahlungsbetrag",
        veh_finance_pay = "Zahlung leisten",
        veh_finance_payoff = "Fahrzeug abbezahlen",
        veh_finance_payment = "Zahlungsbetrag (€)",
        submit_text = "Einreichen",
        test_header = "Probefahrt",
        finance_header = "Fahrzeug finanzieren",
        swap_header = "Fahrzeug tauschen",
        swap_txt = "Aktuell ausgewähltes Fahrzeug ändern",
        financesubmit_downpayment = "Anzahlung - Min ",
        financesubmit_totalpayment = "Gesamtzahlungen - Max ",
        --Free Use
        freeuse_test_txt = "Aktuell ausgewähltes Fahrzeug probefahren",
        freeuse_buy_header = "Fahrzeug kaufen",
        freeuse_buy_txt = "Aktuell ausgewähltes Fahrzeug kaufen",
        freeuse_finance_txt = "Aktuell ausgewähltes Fahrzeug finanzieren",
        --Managed
        managed_test_txt = "Spieler für Probefahrt zulassen",
        managed_sell_header = "Fahrzeug verkaufen",
        managed_sell_txt = "Fahrzeug an Spieler verkaufen",
        managed_finance_txt = "Fahrzeug an Spieler finanzieren",
        submit_ID = "Server-ID (#)",
    },
    general = {
        testdrive_timer = "Verbleibende Probefahrtzeit:",
        vehinteraction = "Fahrzeuginteraktion",
        testdrive_timenoti = "Du hast noch %{testdrivetime} Minuten",
        testdrive_complete = "Probefahrt abgeschlossen",
        paymentduein = "Deine Fahrzeugzahlung ist in %{time} Minuten fällig",
        command_transfervehicle = "Fahrzeug verschenken oder verkaufen",
        command_transfervehicle_help = "ID des Käufers",
        command_transfervehicle_amount = "Verkaufspreis (optional)",
    }
}

if GetConvar('wickx_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
