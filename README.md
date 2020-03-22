# ackersnacker

Finished Project of Team ackersnacker for the #WirvsVirus Hackathon. 

For information on the project, see [our Pitch video](https://www.youtube.com/watch?v=izkkpHKH_qo) or [our DevPost](https://devpost.com/software/ackersnacker)

## Usage

ackersnacker is written in Dart using flutter.

To use, you need to [generate a Google API key](https://developers.google.com/maps/documentation/javascript/get-api-key?hl=de) for use of Maps and Geocoder SDKs and place it in `android/app/src/main/AndroidManifest.xml` as well as `ios/Runner/AppDelegate.swift` at the specified positions (search for `PLACE_GOOGLE_API_KEY_HERE`).
Also, server data have to be transferred from and to a server using the backend in [the backend repository](https://github.com/LSnyd/ackersnackerAPI). For that, the URL to the server needs to be placed in `lib/pages/BauerPage.dart` and `lib/pages/MapPage.dart` at the specified positions (search for `PLACE_YOUR_SERVER_URL_HERE`).

A compiled APK to test the App with a usable API key and running server will be provided shortly.


## Kurzbeschreibung
Ackersnacker ist eine App, die den Kontakt zwischen potenziellen Saisonarbeiter:Innen und Landwirt:Innen ermöglicht und koordiniert. Landwirt:Innen können sich in der App anmelden und für ihren Hof Angebote anmelden. Wenn die Landwirt:Innen ein Angebot anlegen, geben sie die Art, den Ort, die Vergütung und den Zeitraum der Arbeit an. Diese Einträge werden automatisch auf einer Karte eingetragen, welche den Arbeitsuchenden beim Öffnen der App für ihre Region angezeigt wird. Die App ermöglicht es Arbeitssuchenden, sich schnell ein Überblick über die verschiedenen Angebote in ihrer Region zu verschaffen und sich, bei vielversprechenden Angeboten, die Kontaktdaten der Landwirt:In anzeigen zu lassen. Dabei versucht die App im Hintergrund, durch ein paar einfache Regeln & Tricks, das Angebot gleichmäßig auf die Bürger:Innen zu verteilen: Angebote die noch nicht stark besetzt wurden, werden größer auf der Karte angezeigt, und jede Landwirt:In kann nur eine gewisse Anzahl an Plätzen ausschreiben. So wollen wir bewirken, dass einerseits gleichmäßig Arbeitskräfte verteilt werden und anderseits nicht zu großen Gruppen entstehen, die ein Infektionsrisiko für die Arbeitnehmer:Innen und die beteiligten Landwirte bergen. 