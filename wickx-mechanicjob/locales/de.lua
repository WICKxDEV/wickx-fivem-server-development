local Translations = {
    success = {
        tuned = 'Fahrzeug getunt',
        installed = '%s installiert',
        repaired = 'Fahrzeug repariert',
        part_repaired = '%s repariert',
        tire_repaired = 'Reifen repariert',
        cleaned = 'Fahrzeug gereinigt',
    },
    warning = {
        not_tuned = 'Fahrzeug nicht getunt',
        no_materials = 'Nicht genügend Materialien',
    },
    target = {
        duty = 'Dienst umschalten',
        stash = 'Lager',
        shop = 'Shop',
        paint = 'Fahrzeug lackieren',
        withdraw = 'Fahrzeug entnehmen',
        deposit = 'Fahrzeug einlagern',
    },
    menu = {
        none = 'Keine',
        back = 'Zurück',
        close = 'Schließen',
        submit = 'Absenden',
        status = 'Status',
        vehicle_stats = 'Fahrzeugstatistiken',
        engine_health = 'Motorzustand',
        body_health = 'Karosseriezustand',
        fuel_health = 'Tankzustand',
        vehicle_list = 'Fahrzeugliste',
        paint_vehicle = 'Fahrzeug lackieren',
        radiator_repair = 'Kühler',
        axle_repair = 'Achse',
        fuel_repair = 'Kraftstoff',
        clutch_repair = 'Kupplung',
        brakes_repair = 'Bremsen',
        paints = 'Lackierungen',
        type = 'Typ',
        metallic = 'Metallic',
        matte = 'Matt',
        chrome = 'Chrom',
        custom_color = 'Sonderfarbe',
        section = 'Sektion',
        primary = 'Primär',
        secondary = 'Sekundär',
        pearlescent = 'Perlglanz',
        interior = 'Innenraum',
        exterior = 'Außenbereich',
        wheels = 'Räder',
        neons = 'Neonlichter',
        xenon = 'Xenon-Scheinwerfer',
        window_tint = 'Scheibentönungen',
        plate = 'Kennzeichen',
        repair = 'Reparieren',
        unknown = 'Unbekannt',
        tire_smoke = 'Reifenqualm',
        standard = 'Standard',
        custom = 'Benutzerdefiniert',
        toggle = 'Umschalten',
        enabled = 'Aktiviert',
        disabled = 'Deaktiviert',
        color = 'Farbe',
        front_toggle = 'Vorne umschalten',
        rear_toggle = 'Hinten umschalten',
        left_toggle = 'Links umschalten',
        right_toggle = 'Rechts umschalten',
        stock = 'Standard',
        armor = 'Panzerungsstufe',
        brakes = 'Bremsstufe',
        engine = 'Motorstufe',
        transmission = 'Getriebe-Stufe',
        suspension = 'Fahrwerksstufe',
        turbo = 'Turbo',
        install_turbo = 'Turbo installieren',
        uninstall_turbo = 'Turbo deinstallieren',
    },
    progress = {
        nitrous = 'Nitro anschließen',
        installing = 'Installiere %s',
        repairing = 'Repariere %s',
        repair_vehicle = 'Fahrzeug reparieren',
        repair_tire = 'Reifen reparieren',
        cleaning = 'Fahrzeug reinigen',
        tuner_chip = 'Tuner-Chip anschließen',
    }
}

if GetConvar('wickx_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end