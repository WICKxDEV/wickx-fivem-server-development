local Translations = {
    error = {
        blips_deactivated = 'Blips deaktiveret',
        names_deactivated = 'Navne deaktiveret',
        changed_perm_failed = 'Vælg en gruppe!',
        missing_reason = 'Du skal give en grund!',
        invalid_reason_length_ban = 'Du skal give en grund og angive en længde for udelukkelsen!',
        no_store_vehicle_garage = 'Du kan ikke opbevare dette køretøj i din garage..',
        no_vehicle = 'Du er ikke i et køretøj..',
        no_weapon = 'Du har ikke et våben i dine hænder..',
        no_free_seats = 'Køretøjet har ingen ledige sæder!',
        failed_vehicle_owner = 'Dette køretøj er allerede dit..',
        not_online = 'Denne spiller er ikke online',
        no_receive_report = 'Du modtager ikke rapporter',
        failed_set_speed = 'Du har ikke sat en hastighed.. (`fast` for super-run, `normal` for normal)',
        failed_set_model = 'Du har ikke sat en model..',
        failed_entity_copy = 'Ingen freeaim-enhedsoplysninger at kopiere til udklipsholder!',
    },
    success = {
        blips_activated = 'Blips aktiveret',
        names_activated = 'Navne aktiveret',
        coords_copied = 'Koordinater kopieret til udklipsholder!',
        heading_copied = 'Heading kopieret til udklipsholder!',
        changed_perm = 'Myndighedsgruppe ændret',
        entered_vehicle = 'Kom ind i køretøjet',
        success_vehicle_owner = 'Køretøjer er nu dit!',
        receive_reports = 'Du modtager rapporter',
        entity_copy = 'Freeaim-enhedsoplysninger kopieret til udklipsholder!',
    },
    info = {
        ped_coords = 'Ped Koordinater:',
        vehicle_dev_data = 'Køretøj Udvikler Data:',
        ent_id = 'Enheds ID:',
        net_id = 'Net ID:',
        net_id_not_registered = 'Ikke registreret',
        model = 'Model',
        hash = 'Hash',
        eng_health = 'Motor Liv:',
        body_health = 'Body Liv:',
        go_to = 'Gå Til',
        remove = 'Fjern',
        confirm = 'Bekræft',
        reason_title = 'Grund',
        length = 'Længde',
        options = 'Indstillinger',
        position = 'Position',
        your_position = 'til din position',
        open = 'Åben',
        inventories = 'inventories',
        reason = 'du skal give en grund',
        give = 'giv',
        id = 'ID:',
        player_name = 'Spiller Navn',
        obj = 'Obj',
        ammoforthe = '+%{value} Ammunition for %{weapon}',
        kicked_server = 'Du er blevet smidt ud fra serveren',
        check_discord = '🔸 Tjek vores Discord for mere information: ',
        banned = 'Du er blevet udelukket:',
        ban_perm = '\n\nDin udelukkelse er permanent.\n🔸 Tjek vores Discord for mere information: ',
        ban_expires = '\n\nUdelukkelse udløber: ',
        rank_level = 'Dit tilladelsesniveau er nu ',
        admin_report = 'Admin rapport - ',
        staffchat = 'STAFFCHAT - ',
        warning_chat_message = '^8ADVARSEL ^7 Du er blevet advaret af',
        warning_staff_message = '^8ADVARSEL ^7 Du har advaret ',
        no_reason_specified = 'Ingen grund angivet',
        server_restart = 'Server genstart, tjek vores Discord for mere information: ',
        entity_view_distance = 'Enhedsvisningsafstand indstillet til: %{distance} meter',
        entity_view_info = 'Enhedsoplysninger',
        entity_view_title = 'Entity Freeaim Mode',
        entity_freeaim_delete = 'Slet enhed',
        entity_freeaim_freeze = 'Frys enhed',
        entity_frozen = 'Frosset',
        entity_unfrozen = 'Ufrosset',
        model_hash = 'Model hash:',
        obj_name = 'Objektnavn:',
        ent_owner = 'Enhedsejer:',
        cur_health = 'Nuværende helbred:',
        max_health = 'Maksimal sundhed:',
        armour = 'Armor:',
        rel_group = 'Relationsgruppe:',
        rel_to_player = 'Relation til spiller:',
        rel_group_custom = 'Tilpasset forhold',
        veh_acceleration = 'Acceleration:',
        veh_cur_gear = 'Nuværende gear:',
        veh_speed_kph = 'Kph:',
        veh_speed_mph = 'Mph:',
        veh_rpm = 'Omdr./min:',
        dist_to_obj = 'Dist:',
        obj_heading = 'Overskrift:',
        obj_coords = 'Koder:',
        obj_rot = 'Rotation:',
        obj_velocity = 'Hastighed:',
        obj_unknown = 'Ukendt',
        you_have = 'Du har ',
        freeaim_entity = ' freeaim-enheden',
        entity_del = 'Enhed slettet',
        entity_del_error = 'Fejl ved sletning af enhed',
    },
    menu = {
        admin_menu = 'Admin Menu',
        admin_options = 'Admin Indstillinger',
        online_players = 'Online Spillere',
        manage_server = 'Administrer Server',
        weather_conditions = 'Tilgængelige Vejr Indstillinger',
        dealer_list = 'Forhandler Liste',
        ban = 'Udeluk',
        kick = 'Smid ud',
        permissions = 'Tilladelser',
        developer_options = 'Udvikler Indstillinger',
        vehicle_options = 'Køretøj Indstillinger',
        vehicle_categories = 'Køretøj Kategorier',
        vehicle_models = 'Køretøj Modeller',
        player_management = 'Spiller Styrelse',
        server_management = 'Server Styrelse',
        vehicles = 'Køretøjer',
        noclip = 'NoClip',
        revive = 'Genopliv',
        invisible = 'Usynlig',
        god = 'Godmode',
        names = 'Navne',
        blips = 'Blips',
        weather_options = 'Vejr Indstillinger',
        server_time = 'Server Tid',
        time = 'Tid',
        copy_vector3 = 'Kopier vector3',
        copy_vector4 = 'Kopier vector4',
        display_coords = 'Vis Koordinater',
        copy_heading = 'Kopier Heading',
        vehicle_dev_mode = 'Køretøjsudviklingstilstand',
        spawn_vehicle = 'Spawn Køretøj',
        fix_vehicle = 'Reparer Køretøj',
        buy = 'Køb',
        remove_vehicle = 'Fjern Køretøj',
        edit_dealer = 'Rediger Forhandler ',
        dealer_name = 'Forhandler Navn',
        category_name = 'Kategori Navn',
        kill = 'Dræb',
        freeze = 'Frys',
        spectate = 'Spectate',
        bring = 'Bring',
        sit_in_vehicle = 'Sid i køretøj',
        open_inv = 'Åben Inventar',
        give_clothing_menu = 'Giv Tøj Menu',
        hud_dev_mode = 'Udvikler Tilstand (wickx-hud)',
        entity_view_options = 'Enhedsvisningstilstand',
        entity_view_distance = 'Indstil visningsafstand',
        entity_view_freeaim = 'Freeaim-tilstand',
        entity_view_peds = 'Vis Peds',
        entity_view_vehicles = 'Visningskøretøjer',
        entity_view_objects = 'Vis objekter',
        entity_view_freeaim_copy = 'Kopiér Freeaim-enhedsoplysninger',
    },
    desc = {
        admin_options_desc = 'Misc. Admin Indstillinger',
        player_management_desc = 'Vis Liste Af Spillere',
        server_management_desc = 'Misc. Server Indstillinger',
        vehicles_desc = 'Køretøjs Indstillinger',
        dealer_desc = 'Liste af eksisterende forhandlere',
        noclip_desc = 'Aktiver/Deaktiver NoClip',
        revive_desc = 'Genopliv Dig Selv',
        invisible_desc = 'Aktiver/Deaktiver Usynlighed',
        god_desc = 'Aktiver/Deaktiver God Mode',
        names_desc = 'Aktiver/Deaktiver Names overhead',
        blips_desc = 'Aktiver/Deaktiver Blips for players in maps',
        weather_desc = 'Skift Vejret',
        developer_desc = 'Misc. Udvikler Indstillinger',
        vector3_desc = 'Kopier vector3 Til Udklipsholder',
        vector4_desc = 'Kopier vector4 Til Udklipsholder',
        display_coords_desc = 'Vis Koordinater På Skærm',
        copy_heading_desc = 'Kopier Heading til Udklipsholder',
        vehicle_dev_mode_desc = 'Vis Køretøjsinformation',
        delete_laser_desc = 'Aktiver/Deaktiver Laser',
        spawn_vehicle_desc = 'Spawn et køretøj',
        fix_vehicle_desc = 'Reparer køretøjer du er i',
        buy_desc = 'Køb køretøjet gratis',
        remove_vehicle_desc = 'Fjern nærmeste køretøj',
        dealergoto_desc = 'Gå til forhandler',
        dealerremove_desc = 'Fjern forhandler',
        kick_reason = 'Kick Grund',
        confirm_kick = 'Bekræft Kicket',
        ban_reason = 'Udelukkelse grund',
        confirm_ban = 'Bekræft udelukkelsen',
        sit_in_veh_desc = 'Sid i',
        sit_in_veh_desc2 = "'s køretøj",
        clothing_menu_desc = 'Giv tøj menuen til',
        hud_dev_mode_desc = 'Aktiver/Deaktiver Udvikler Tilstand',
        entity_view_desc = 'Se oplysninger om enheder',
        entity_view_freeaim_desc = 'Aktiver/deaktiver enhedsoplysninger via freeaim',
        entity_view_peds_desc = 'Aktiver/deaktiver ped-oplysninger i verden',
        entity_view_vehicles_desc = 'Aktiver/deaktiver køretøjsoplysninger i verden',
        entity_view_objects_desc = 'Aktiver/deaktiver objektinfo i verden',
        entity_view_freeaim_copy_desc = 'Kopierer oplysningerne om Free Aim-enheden til udklipsholder',
    },
    time = {
        ban_length = 'Udelukkelse Længde',
        onehour = '1 Time',
        sixhour = '6 Timer',
        twelvehour = '12 Timer',
        oneday = '1 Dag',
        threeday = '3 Dage',
        oneweek = '1 Uge',
        onemonth = '1 Måned',
        threemonth = '3 Måneder',
        sixmonth = '6 Måneder',
        oneyear = '1 År',
        permanent = 'Permanent',
        self = 'Self',
        changed = 'Tid ændret til %{time} hs 00 min',
    },
    weather = {
        extra_sunny = 'Ekstra solrig',
        extra_sunny_desc = 'Jeg smelter!',
        clear = 'Klart',
        clear_desc = 'Den perfekte dag!',
        neutral = 'Neutral',
        neutral_desc = 'Bare en almindelig dag!',
        smog = 'Smog',
        smog_desc = 'Røg Maskine!',
        foggy = 'Tåget',
        foggy_desc = 'Røg Maskine x2!',
        overcast = 'Overskyet',
        overcast_desc = 'Ikke for solrig!',
        clouds = 'Skyet',
        clouds_desc = 'Hvor er solen?',
        clearing = 'Klaring',
        clearing_desc = 'Skyer begynder at klare!',
        rain = 'Regn',
        rain_desc = 'Få det til at regne!',
        thunder = 'Torden',
        thunder_desc = 'Løb og skjul!',
        snow = 'Sne',
        snow_desc = 'Er det koldt herude?',
        blizzard = 'Snestorm',
        blizzed_desc = 'Sne Maskine?',
        light_snow = 'Let Sne',
        light_snow_desc = 'Begynder at få lyst til jul!',
        heavy_snow = 'Tung Sne (JUL)',
        heavy_snow_desc = 'Sneboldskamp!',
        halloween = 'Halloween',
        halloween_desc = 'Hvad var den støj?!',
        weather_changed = 'Vejr ændret til: %{value}',
    },
    commands = {
        blips_for_player = 'Vis Blips For Spillere (Kun Admin)',
        player_name_overhead = 'Vis Spiller Navn Over Hovedet (Kun Admin)',
        coords_dev_command = 'Aktiver visning af koordinater for udviklingsting (Kun Admin)',
        toogle_noclip = 'Noclip til/fra (Kun Admin)',
        save_vehicle_garage = 'Gem Køretøj Til Din Garage (Kun Admin)',
        make_announcement = 'Lav En Meddelelse (Kun Admin)',
        open_admin = 'Åben Admin Menu (Kun Admin)',
        staffchat_message = 'Send En Besked Til Alle Staffs (Kun Admin)',
        nui_focus = 'Giv En Spiller NUI Focus (Kun Admin)',
        warn_a_player = 'Advar En Spiller (Kun Admin)',
        check_player_warning = 'Tjek Spiller Advarsler (Kun Admin)',
        delete_player_warning = 'Slet Spiller Advarsler (Kun Admin)',
        reply_to_report = 'Svar På En Rapport (Kun Admin)',
        change_ped_model = 'Skift Ped Model (Kun Admin)',
        set_player_foot_speed = 'Skift spillerens fodhastighed (Kun Admin)',
        report_toggle = 'Skift Indgående Rapporter til/fra (Kun Admin)',
        kick_all = 'Smid Alle Spillere Ud',
        ammo_amount_set = 'Indstil dit ammunitionsbeløb (Kun Admin)',
    }
}

if GetConvar('wickx_locale', 'en') == 'da' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
