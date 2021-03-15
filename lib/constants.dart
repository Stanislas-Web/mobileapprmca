import 'package:flutter/material.dart';

// const KPrimaryColor = Color(0xFF0C9869);
// const KPrimaryColor = Colors.amber[400];
const KTextColor = Color(0xFF3C4046);
const KbackgroundColor = Color(0xFFF9F8FD);
const double KDefaultPadding = 20.0;

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Veuillez entrer votre Adresse Email";
const String kInvalidEmailError = "Veuillez entrer un Email valide";
const String kPassNullError = "Veuillez entrer votre Code Pin";
const String kShortPassError = "Le Code Pin doit contenir 4 chiffres";
const String kMatchPassError = "Les codes pin ne correspondent pas";
const String kNamelNullError = "S'il vous plaît entrez votre nom";
const String kPrenomNullError = "S'il vous plaît entrez votre prénom";
const String kPhoneNumberNullError =
    "Veuillez entrer votre numéro de téléphone";
const String kAddressNullError = "S'il vous plaît entrez votre adresse";
const String kObjetNullError = "S'il vous plaît entrez l'objet du message";
const String kMessageNullError = "S'il vous plaît entrez votre message";
const String kVilleNullError = "La ville ne peut pas être vide";
const String kPinNullError = "SVP, Entrez votre code Pin";
const String kMontantNullError = "Le montant ne peut pas être vide";
const String kCompteNullError = "SVP, Entrez votre Numéro de Compte";
const String kDeviseNullError = "La devise ne peut pas être vide";
const String kPaysNullError = "Le Pays ne peut pas être vide";
const String kOperateurNullError = "L'Opérateur ne peut pas être vide";
const String kFormuleNullError = "La Formule ne peut pas être vide";
const String kCodeDecodeuNullError = "Le Code Decodeur ne peut pas être vide";
const String kCreatedNullError = "La date ne peut pas être vide";
const String kCVVNullError = "Le Numéro CVV ne peut pas être vide";
const String kNumberCarteNullError = "Le Numéro Carte ne peut pas être vide";
const String kCompteNameNullError = "Le Nom de la carte ne peut pas être vide";
const String kIdClientNullError = "L' ID - Client ne peut pas être vide";
const String kMotifNullError = "Le Motif ne peut pas être vide";
const String kConfirmPinNullError = "Le Pin de Confirmation est vide";
const String kNewPinNullError = "Le Nouveau Pin ne peut pas être vide";
const String kNomNullError = "Le nom ne peut pas être vide";
const String kAdresseNullError = "L'adresse ne peut pas être vide";
const String kDateNullError = "La Date ne peut pas être vide";
