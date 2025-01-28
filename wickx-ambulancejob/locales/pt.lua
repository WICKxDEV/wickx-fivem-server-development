local Translations = {
    error = {
        canceled = 'Cancelado',
        bled_out = 'Esvaíste-te em sangue...',
        impossible = 'Acção Impossível...',
        no_player = 'Nenhum Jogador Perto',
        no_firstaid = 'Necessitas de um Estojo de Primeiros Socorros',
        no_bandage = 'Necessitas de uma Ligadura',
        beds_taken = 'Camas ocupadas...',
        possessions_taken = 'Todas as tuas posses foram removidas...',
        not_enough_money = 'Não tens dinheiro suficiente contigo...',
        cant_help = 'Não podes ajudar esta pessoa...',
        not_ems = 'Não pertences ao EMS',
        not_online = 'Jogador Desligado'
    },
    success = {
        revived = 'Reviveste uma pessoa',
        healthy_player = 'Jogador Saudável',
        helped_player = 'Ajudaste a pessoa',
        wounds_healed = 'Os teus ferimentos foram curados!',
        being_helped = 'Estão a ajudar-te...'
    },
    info = {
        civ_died = 'Cidadão morreu',
        civ_down = 'Cidadão caído',
        civ_call = 'Chamada de cidadão',
        self_death = 'Eles próprios ou um NPC',
        wep_unknown = 'Desconhecido',
        respawn_txt = 'RENASCER EM: ~r~%{deathtime}~s~ SEGUNDOS',
        respawn_revive = 'PRESSIONA [~r~E~s~] DURANTE %{holdtime} SGUNDOS PARA RENASCERES POR $~r~%{cost}~s~',
        bleed_out = 'ESVAIR-TE-ÁS EM SANGUE DENTRO DE: ~r~%{time}~s~ SEGUNDOS',
        bleed_out_help = 'ESVAIR-TE-ÁS EM SANGUE DENTRO DE: ~r~%{time}~s~ SEGUNDOS, AINDA PODES SER AJUDADO',
        request_help = 'PRESSIONA [~r~G~s~] PARA PEDIR AJUDA',
        help_requested = 'OS SERVIÇOS DE EMS FORAM NOTIFICADOS',
        amb_plate = 'AMBU', -- Should only be 4 characters long due to the last 4 being a random 4 digits
        heli_plate = 'VIDA',  -- Should only be 4 characters long due to the last 4 being a random 4 digits
        status = 'Verificação de Estado',
        is_status = 'Encontra-se %{status}',
        healthy = 'Estás novamente saudável!',
        safe = 'Hospital Seguro',
        pb_hospital = 'Pillbox Hospital',
        pain_message = 'O(s) teu(s) %{limb} sente-se %{severity}',
        many_places = 'Tens dores em váios locais...',
        bleed_alert = 'Tu estás %{bleedstate}',
        ems_alert = 'Alerta EMS - %{text}',
        mr = 'Sr.',
        mrs = 'Sra.',
        dr_needed = 'Solicita-se a presença de um Médico no Pillbox Hospital',
        ems_report = 'Relatório EMS',
        message_sent = 'Mensagem a ser enviada',
        check_health = 'Verificar a Saúde de Paciente',
        heal_player = 'Curar um Paciente',
        revive_player = 'Reviver um Paciente',
        revive_player_a = 'Reviver um Paciente ou tu mesmo (Somente Admin)',
        player_id = 'ID do Jogador (opcional)',
        pain_level = 'Define o nįvel de dor a ti ou a outro jogador (Somente Admin)',
        kill = 'Matar um jogador ou a ti próprio (Somente Admin)',
        heal_player_a = 'Curar um jogador ou a ti próprio (Somente Admin)',
    },
    mail = {
        sender = 'Hospita Pillbox',
        subject = 'Custos Hospitalares',
        message = 'Caro(a) %{gender} %{lastname}, <br /><br />Anexado a este email encontram-se os custos da sua ultima visita ao nosso Hospital.<br />O valor total foi de: <strong>$%{costs}</strong><br /><br />Desejamos-lhe uma rápida recuperação!'
    },
    states = {
        irritated = 'irritado',
        quite_painful = 'um pouco doloroso',
        painful = 'doloroso',
        really_painful = 'bastante doloroso',
        little_bleed = 'a sangrar um pouco...',
        bleed = 'a sangrar...',
        lot_bleed = 'a sangrar bastante...',
        big_bleed = 'a sangrar terrivelmente...',
    },
    menu = {
        amb_vehicles = 'Veiculos de Emergência',
        close = '⬅ Fechar Menu',
    },
    text = {
        pstash_button = '~g~E~w~ - Cacifo Pessoal',
        pstash = 'Cacifo Pessoal',
        onduty_button = '~g~E~w~ - Entrar em Serviço',
        offduty_button = '~r~E~w~ - Sair de Serviço',
        duty = 'Entrar/Sair de Serviço',
        armory_button = '~g~E~w~ - Armeiro',
        armory = 'Armeiro',
        storeveh_button = '~g~E~w~ - Guardar veículo',
        veh_button = '~g~E~w~ - Veícuklos',
        storeheli_button = '~g~E~w~ - Guardar helicoptero',
        heli_button = '~g~E~w~ - Tirar helicoptero',
        elevator_roof = '~g~E~w~ - Apanhar elevador para a cobertura',
        elevator_main = '~g~E~w~ - Apanhar elevador para baixo',
        bed_out = '~g~E~w~ - Sair da cama...',
        call_doc = '~g~E~w~ - Chamar Médico',
        call = 'Chamar',
        check_in = '~g~E~w~ - Dar Entrada',
        check = 'Entrada',
        lie_bed = '~g~E~w~ - Deitar na cama'
    },
    body = {
        head = 'Cabeça',
        neck = 'Pescoço',
        spine = 'Coluna',
        upper_body = 'Membros Superiores',
        lower_body = 'Membros Inferiores',
        left_arm = 'Braço Esquerdo',
        left_hand = 'Mão Esquerda',
        left_fingers = 'Dedos Esquerdos',
        left_leg = 'Perna Esquerda',
        left_foot = 'Pé Esquerdo',
        right_arm = 'Braço Direito',
        right_hand = 'Mão Direita',
        right_fingers = 'Dedos Direitos',
        right_leg = 'Perna Direita',
        right_foot = 'Pé Direito',
    },
    progress = {
        ifaks = 'A tomar ifaks...',
        bandage = 'A utilizar Ligadura...',
        painkillers = 'A tomar Analgésico...',
        revive = 'A Reanimar Pessoa...',
        healing = 'A Curar Ferimentos...',
        checking_in = 'A Dar Entrada...',
    },
    logs = {
        death_log_title = "%{playername} (%{playerid}) foi morto",
        death_log_message = "%{killername} foi morto %{playername} com uma **%{weaponlabel}** (%{weaponname})",
    }
}

if GetConvar('wickx_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
