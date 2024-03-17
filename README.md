# Sistema di Gestione Cinema

Questo repository contiene gli script SQL e le stored procedure per la gestione del database di un cinema. Lo schema del database include tabelle per cinema, sale, film, orari delle proiezioni, clienti, biglietti, recensioni e dipendenti.

## Indice
- [Panoramica](#panoramica)
- [Schema del Database](#schema-del-database)
- [Viste](#viste)
- [Stored Procedure](#stored-procedure)
- [Utilizzo](#utilizzo)

## Panoramica
Questo sistema di database è progettato per gestire le operazioni di un cinema. Consente di memorizzare e recuperare informazioni relative a cinema, film, orari delle proiezioni, clienti, biglietti, recensioni e dipendenti. Il sistema fornisce funzionalità come l'acquisto di biglietti, l'aggiornamento degli orari dei film e l'inserimento di nuovi film nel database.

## Schema del Database
Lo schema del database è composto dalle seguenti tabelle:
- **Cinema**: Memorizza informazioni sui cinema, tra cui nome, indirizzo e numero di telefono.
- **Theater**: Contiene dettagli sulle sale all'interno dei cinema, come capacità e tipo di schermo.
- **Movie**: Memorizza informazioni sui film, inclusi titolo, regista, data di uscita, durata e rating.
- **ShowTime**: Rappresenta gli orari delle proiezioni programmate per i film nelle sale, inclusa data, ora e prezzo.
- **Customer**: Memorizza informazioni sui clienti come nome, email e numero di telefono.
- **Ticket**: Contiene dettagli sui biglietti acquistati dai clienti per specifici orari delle proiezioni.
- **Review**: Memorizza le recensioni dei film fornite dai clienti, incluse il testo, il rating e la data della recensione.
- **Employee**: Memorizza informazioni sui dipendenti del cinema, inclusa la loro posizione e la data di assunzione.

## Viste
Sono state create diverse viste per un recupero più facile dei dati:
- **FilmInProgrammation**: Mostra i film attualmente in programmazione nei cinema, insieme agli orari delle proiezioni, ai prezzi e ai rating.
- **AvaibleSeatsForShow**: Fornisce informazioni sui posti disponibili per ciascun orario delle proiezioni, inclusi i posti totali e quelli rimanenti.
- **TotalEarningsPerMovie**: Mostra i guadagni totali generati da ciascun film in base alle vendite dei biglietti.
- **RecentReviews**: Elenca le recensioni recenti dei film insieme ai loro rating, testi e date di recensione.

## Stored Procedure
Le seguenti stored procedure sono disponibili per le operazioni del database:
- **PurchaseTicket**: Consente ai clienti di acquistare biglietti per orari specifici delle proiezioni. Controlla la disponibilità dei posti prima di completare l'acquisto.
- **UpdateMovieSchedule**: Consente di aggiornare gli orari dei film modificando gli orari delle proiezioni esistenti o eliminando quelli esistenti per un film.
- **InsertNewMovie**: Facilita l'inserimento di nuovi film nel database con validazioni per i campi obbligatori.

## Utilizzo
Per interagire con il database, eseguire gli script SQL forniti per la creazione di tabelle, viste e stored procedure. Dopo aver configurato il database, utilizzare le stored procedure per eseguire varie operazioni come l'acquisto di biglietti, l'aggiornamento degli orari dei film e l'aggiunta di nuovi film. Assicurarsi di fornire i parametri necessari durante l'esecuzione delle stored procedure per ottenere la funzionalità desiderata.

Per istruzioni dettagliate su ciascuna stored procedure e vista, fare riferimento alla documentazione.
