local Translations = {
    error = {
        has_no_drugs = "Vous n'avez pas de drogue sur vous",
        not_enough_police = "Il n'y a pas assez de policiers en service (%{polices} requis)",
        no_drugs_left = "Plus de drogue a vendre",
        too_far_away = "Vous êtes allé trop loin",
        offer_declined = "Offre refusée",
        no_player_nearby = "Aucun joueur proche",
        pending_delivery = "Vous avez une livraison a finir, Qu'attendez vous?!",
        item_unavailable = "Cet objet n'est pas disponible, Vous avez été remboursé",
        order_not_right = "Cela n'est pas la commande",
        too_late = "Vous êtes arrivé trop tard",
        dealer_already_exists = "Un dealeur avec ce nom existe déjà",
        dealer_not_exists = "Ce dealeur n'existe pas",
        no_dealers = "Aucun dealeur n'a été placé",
        dealer_not_exists_command = "Dealeur %{dealerName} n'existe pas",
        delivery_fail = "",
    },
    success = {
        helped_player = "Vous avez aidé un joueur",
        route_has_been_set = "La route vers votre déstination à été mise sur votre GPS",
        teleported_to_dealer = "Vous avez été téléporté à %{dealerName}",
        offer_accepted = "offre accepté",
        order_delivered = "La commande a été livrée",
        dealer_deleted = "Dealeur %{dealerName} à été supprimé"
    },
    info = {
        started_selling_drugs = "Vous avez commencé a vendre de la drogue",
        stopped_selling_drugs = "Vous avez arreté de vendre de la drogue",
        has_been_robbed = "Vous avez été dépouillé et avez perdu %{bags} sac(s) %{drugType}",
        suspicious_situation = "Situation suspicieuse",
        possible_drug_dealing = "Potentiel deal de drogue",
        drug_offer = "[E] %{bags}x %{drugLabel} pour $%{randomPrice}? / [G] Refuser l'offre",
        target_drug_offer = "Vendre %{bags}x %{drugLabel} Pour $%{randomPrice}?",
        search_ped = "Fouiller",
        pick_up_button = "[E] Prendre",
        knock_button = "[E] Toquer",
        target_knock = 'Toquer',
        target_deliver = 'Livrer Drogues',
        target_openshop = 'Ouvrir Shop',
        target_request = 'Demander Livraison',
        mystery_man_button = "[E] Acheter / [G] Aider le dealer ($5000)",
        other_dealers_button = "[E] Acheter / [G] Commencer une mission",
        reviving_player = "Aide la personne...",
        dealer_name = "Dealeur %{dealerName}",
        sending_delivery_email = "Ce sont les produits, Je te recontacterais par E-Mail",
        mystery_man_knock_message = "Bonjour mon enfant, Que puis-je faire pour toi?",
        treated_fred_bad = "Malheureusement je ne fais plus de business... Tu aurais dû me traiter mieux",
        fred_knock_message = "Yo %{firstName}, Qu'est-ce-que je peux faire pour toi?",
        no_one_home = "On dirais que personne n'est là",
        delivery_info_email = "Voilà les infos sur la livraison, <br>Objets: <br> %{itemAmount}x %{itemLabel}<br><br> Soit a l'heure",
        deliver_items_button = "[E] Livrer %{itemAmount}x %{itemLabel}",
        delivering_products = "Livraison...",
        drug_deal_alert = "911: Deal de drogue",
        perfect_delivery = "Tu a fait du bon taf, En espérant te revoir ;)<br><br>Cordialement, %{dealerName}",
        bad_delivery = "J'ai reçu des plainte par rapport a ta dernière livraison, Que ça n'arrive pas encore",
        late_delivery = "Tu était en retard. Avais-tu quelque chose de plus important a faire que le business?",
        police_message_server = "Une situation suspicieuse à été localisée sur %{street}, potentiel deal de drogue",
        drug_deal = "Deal de drogue",
        newdealer_command_desc = "Placer un dealeur (Admin Only)",
        newdealer_command_help1_name = "nom",
        newdealer_command_help1_help = "nom du Dealeur",
        newdealer_command_help2_name = "min",
        newdealer_command_help2_help = "Temps minimum",
        newdealer_command_help3_name = "max",
        newdealer_command_help3_help = "Temps Maximum",
        deletedealer_command_desc = "Supprimer un dealeur (Admin Only)",
        deletedealer_command_help1_name = "nom",
        deletedealer_command_help1_help = "Nom du Dealeur",
        dealers_command_desc = "Voir tout les dealeurs (Admin Only)",
        dealergoto_command_desc = "Se teleporter a un dealeur (Admin Only)",
        dealergoto_command_help1_name = "nom",
        dealergoto_command_help1_help = "Nom du Dealeur",
        list_dealers_title = "Liste de tous les dealeurs: ",
        list_dealers_name_prefix = "Nom: ",
        delivery_search = "",
    }
}

if GetConvar('wickx_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
