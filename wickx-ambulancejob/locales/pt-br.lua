local Translations = {
    error = {
        canceled = 'Cancelada',
        bled_out = 'Você sangrou...',
        impossible = 'Ação impossível...',
        no_player = 'Nenhum jogador próximo',
        no_firstaid = 'Você precisa de um kit de primeiros socorros',
        no_bandage = 'Você precisa de um curativo',
        beds_taken = 'As macas estão ocupadas...',
        possessions_taken = 'Todas as suas posses foram tomadas...',
        not_enough_money = 'Você não tem dinheiro suficiente com você...',
        cant_help = 'Você não pode ajudar essa pessoa...',
        not_ems = 'Você não faz parte do Serviço Médico Emergencial(EMS) ou não está em serviço',
        not_online = 'Jogador não está online'
    },
    success = {
        revived = 'Você reviveu uma pessoa',
        healthy_player = 'O jogador está saudável',
        helped_player = 'Você ajudou a pessoa',
        wounds_healed = 'Suas feridas foram curadas!',
        being_helped = 'Estão ajudando você...'
    },
    info = {
        civ_died = 'Civil morreu',
        civ_down = 'Civil desmaiou',
        civ_call = 'Chamada civil        ',
        self_death = 'Eles mesmos ou um NPC',
        wep_unknown = 'Desconhecido',
        respawn_txt = 'RENASCER EM: ~r~%{deathtime}~s~ Segundos',
        respawn_revive = 'AGUARDE [~r~E~s~] por %{holdtime} SEGUNDOS PARA RENASCER $~r~%{cost}~s~',
        bleed_out = 'VOCÊ VAI SANGRAR EM: ~r~%{time}~s~ Segundos',
        bleed_out_help = 'VOCÊ VAI SANGRAR EM: ~r~%{time}~s~ SEGUNDOS, VOCÊ PODE SER AJUDADO',
        request_help = 'PRESSIONE [~r~G~s~] PARA SOLICITAR AJUDA',
        help_requested = 'O PESSOAL DO EMS FOI NOTIFICADO',
        amb_plate = 'AMBU', -- Should only be 4 characters long due to the last 4 being a random 4 digits
        heli_plate = 'LIFE',  -- Should only be 4 characters long due to the last 4 being a random 4 digits
        status = 'Verificação de status',
        is_status = 'É %{status}',
        healthy = 'Você está completamente saudável novamente!',
        safe = 'Cofre Hospitalar',
        pb_hospital = 'HospitalPillbox',
        pain_message = 'Sua %{limb} sente %{severity}',
        many_places = 'Você tem dor em muitos lugares...',
        bleed_alert = 'Voê está %{bleedstate}',
        ems_alert = 'Alerta EMS - %{text}',
        mr = 'Sr.',
        mrs = 'Sra.',
        dr_needed = 'Um médico é necessário no Hospital Pillbox',
        ems_report = 'Relatório EMS',
        message_sent = 'Mensagem a enviar',
        check_health = 'Verifique a saúde de um jogador',
        heal_player = 'Curar um jogador',
        revive_player = 'Reviver um jogador',
        revive_player_a = 'Reviva um jogador ou você mesmo(Somente admin)',
        player_id = 'ID do Jogador (Pode estar vazio)',
        pain_level = 'Defina o nível de dor de você mesmou ou de um jogador(Somente admin)',
        kill = 'Mate um jogador ou você mesmo(Somente admin)',
        heal_player_a = 'Cure um jogador ou você mesmo(Somente admin)',
    },
    mail = {
        sender = 'Hospital Pillbox',
        subject = 'Custos Hospitalares',
        message = 'Querido %{gender} %{lastname}, <br /><br />Por este meio você recebeu um e-mail com os custos da última visita ao hospital.<br />Os custos finais foram: <strong>$%{costs}</strong><br /><br />Desejamos uma rápida recuperação!',
    },
    states = {
        irritated = 'irritado',
        quite_painful = 'bastante doloroso',
        painful = 'doloroso',
        really_painful = 'realmente doloroso',
        little_bleed = 'sangrando um pouco...',
        bleed = 'sangrando...',
        lot_bleed = 'sangrando muito...',
        big_bleed = 'sangrando bastante...',
    },
    menu = {
        amb_vehicles = 'Veículos de ambulância',
        status = 'Estado de saúde',
        close = '⬅ Fechar Menu',
    },
    text = {
        pstash_button = '[E] - Esconderijo pessoal',
        pstash = 'Esconderijo pessoal',
        onduty_button = '[E] - Entrar em serviço',
        offduty_button = '[E] - Sair de serviço',
        duty = 'Entrar/Sair de serviço',
        armory_button = '[E] - Arsenal',
        armory = 'Arsenal',
        veh_button = '[E] - Retirar / Guardar Veículo',
        heli_button = '[E] - Retirar / Guardar Helicóptero',
        elevator_roof = '[E] - Pegue o elevador para o terraço',
        elevator_main = '[E] - Desça o elevador',
        bed_out = '[E] - Para sair da maca..',
        call_doc = '[E] - Ligue para o médico',
        call = 'Ligar',
        check_in = '[E] Check in',
        check = 'Check In',
        lie_bed = '[E] - Para deitar na maca'
    },
    body = {
        head = 'Cabeça',
        neck = 'Pescoço',
        spine = 'Coluna',
        upper_body = 'Tronco',
        lower_body = 'Quadril',
        left_arm = 'Braço esquerdo',
        left_hand = 'Mão esquerda',
        left_fingers = 'Dedos Esquerdos',
        left_leg = 'Perna esquerda',
        left_foot = 'Pé esquerdo',
        right_arm = 'Braço direito',
        right_hand = 'Mão direita',
        right_fingers = 'Dedo Direito',
        right_leg = 'Perna direita',
        right_foot = 'Pé direito',
    },
    progress = {
        ifaks = 'Tomando ifaks...',
        bandage = 'Usando curativo...',
        painkillers = 'Tomando analgésicos...',
        revive = 'Ressuscitando Pessoa...',
        healing = 'Cicatrizando feridas...',
        checking_in = 'Efetuando check-in...',
    },
    logs = {
        death_log_title = "%{playername} (%{playerid}) está morto",
        death_log_message = "%{killername} matou %{playername} com um **%{weaponlabel}** (%{weaponname})",
    }
}

if GetConvar('wickx_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end