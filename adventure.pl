/* The quest of Bananine */
/* PARP, zespół 21              */
/*      Jakub Budrewicz         */
/*      Marcel Jarosz           */
/*      Przemysław Rozwałka     */


:- dynamic jestem_w/1, przedmiot_w/2, postać_w/2, trzymasz/1, zadania/1 .
:- retractall(przedmiot_w(_, _)), retractall(jestem_w(_)), retractall(postać_w(_)), retractall(żywy(_)).

jestem_w(dżungla).

droga(dżungla, północ, polanka).
droga(polanka, południe, dżungla).

droga(polanka, wschód, rozwidlenie).
droga(rozwidlenie, zachód, polanka).

droga(polanka, zachód, klasztor).
droga(klasztor, wschód, polanka).

droga(klasztor, północ, jaskinia_próby) :- zadania(wejdź_do_jaskini_próby), \+zadania(przeszedłeś_próbę).
droga(klasztor, północ, jaskinia_próby) :-
        write('Wejście do tej jaskini jest zapieczętowane.'), nl,
        !, fail.

droga(rozwidlenie, południe, jaskinia_kobry).
droga(jaskinia_kobry, północ, rozwidlenie).

droga(rozwidlenie, północ, kamieniołom).
droga(kamieniołom, południe, rozwidlenie).

droga(rozwidlenie, wschód, dziedziniec_fortu).
droga(dziedziniec_fortu, zachód, rozwidlenie).

droga(dziedziniec_fortu, wschód, fort) :- \+żywy(andrzej).
droga(dziedziniec_fortu, wschód, fort) :- 
        write('Andrzej łapie cię za rękę i mówi: '), nl, nl,
        write(' " Nigdzie się nie wybierasz!'), nl,
        write('   Zmiataj stąd! "'), nl, nl,
        !, fail.

droga(fort, zachód, dziedziniec_fortu).


/* lokalizacje */

postać_w(koko, polanka).
postać_w(bobo, polanka).
postać_w(uebe, klasztor).
postać_w(gnom, jaskinia_próby).
postać_w(pająk, jaskinia_kobry).
postać_w(andrzej, dziedziniec_fortu).

przedmiot_w(banan, dżungla).

/* żywe postacie (zabijalne) */
żywy(pająk).
żywy(andrzej).

/* Podnoszenie rzeczy */

podnieś(X) :-
        trzymasz(X),
        write('Masz już ten przedmiot!'),
        !, nl.

podnieś(X) :-
        jestem_w(Miejsce),
        przedmiot_w(X, Miejsce),
        retract(przedmiot_w(X, Miejsce)),
        assert(trzymasz(X)),
        write('Podniosłeś '), write(X),
        !, nl.

podnieś(_) :-
        write('Nie ma tu takiego przedmiotu.'),
        nl.


/* Odkładanie rzeczy */

upuść(X) :-
        trzymasz(X),
        jestem_w(Miejsce),
        retract(trzymasz(X)),
        assert(przedmiot_w(X, Miejsce)),
        write('Upuściłeś '), write(X),
        !, nl.

upuść(_) :-
        write('Nie trzymasz tego!'),
        nl.


r(Postać) :- rozmawiaj(Postać).
/* Strony świata */

n :- idź(północ).
s :- idź(południe).
e :- idź(wschód).
w :- idź(zachód).

północ :- idź(północ).
południe :- idź(południe).
wschód :- idź(wschód).
zachód :- idź(zachód).

/* Poruszanie się */

teleport(To) :-
        retractall(jestem_w(_)),
        assert(jestem_w(To)).

idź(Direction) :-
        jestem_w(Here),
        droga(Here, Direction, There),
        retract(jestem_w(Here)),
        assert(jestem_w(There)),
        !, gdzie_jestem.

idź(_) :-
        write('Nie możesz tędy iść.').


/* Informacje o miejscu */

gdzie_jestem :-
        jestem_w(Miejsce),
        opisz(Miejsce),
        nl,
        wypisz_przedmioty_w(Miejsce),
        wypisz_postacie_w(Miejsce),
        !, nl.

ekwipunek :-
        trzymasz(_),
        write('W twoim ekwipunku znajdują się:'), nl,
        forall(trzymasz(X), (write('\t* '), write(X), nl)), !.

ekwipunek :-
        write('Twój ekwipunek jest pusty.').

wypisz_przedmioty_w(Miejsce) :-
        przedmiot_w(_, Miejsce),
        write('Możesz podnieść: '), nl,
        forall(przedmiot_w(X, Miejsce), (write('\t* '), write(X), nl)), !.

wypisz_przedmioty_w(_).

wypisz_postacie_w(Miejsce) :-
        postać_w(_, Miejsce),
        write('Zauważasz postacie: '), nl,
        forall(postać_w(X, Miejsce), (write('\t* '), write(X), nl)), !.

wypisz_postacie_w(_).

/* Śmierć */

śmierć :-
        nl,
        write('Umarłeś.'),
        zakończ.


zakończ :-
        nl,
        write('Koniec gry.'),
        nl,
        halt.


/* Pomoc */

pomoc :-
        nl,
        write('Witaj w menu pomocy:'), nl,
        write(' - Imiona postaci i przedmiotów '), nl,
        write('   należy wpisywać z małych liter'), nl,
        write(' - Odpowiedzi tekstowe należy '), nl,
        write('   także zakończyć kropką'), nl,
        write('Dostępne komendy:'), nl,
        write(' - start.                                   -- rozpocznij grę.'), nl,
        write(' - północ. południe. zachód. wschód.        -- idź w daną stronę.'), nl,
        write(' - n, s, w, e.                              -- idź w daną stronę.'), nl,
        write(' - podnieś(Obiekt).                         -- podnieś obiekt.'), nl,
        write(' - upuść(Obiekt).                           -- odłóż obiekt.'), nl,
        write(' - rozmawiaj(Postać). r(Postać).            -- rozmawiaj z postacią.'), nl,
        write(' - atakuj(Postać).                          -- zaatakuj postać.'), nl,
        write(' - gdzie_jestem.                            -- rozejrzyj się.'), nl,
        write(' - ekwipunek.                               -- obejrzyj ekwipunek'), nl,
        write(' - pomoc.                                   -- wyświetl tą wiadomość.'), nl,
        write(' - halt.                                    -- zakończ grę.'), nl,
        nl.


/* Początek gry */

start :-
        pomoc,
        gdzie_jestem.


/* opis miejsc */

opisz(rozwidlenie) :- 
        write('Zbliżasz się do rozwidlenia świeżki.'), nl,
        write('Na wschodzie wznosi się spory fort kłusowników,'), nl,
        write('zaś na zachodzie znajduje się polanka Goryli.'), nl,
        write('Na północy widzisz mroczny kamieniołom.'), nl,
        write('Na południu dostrzegasz wejście do przerażającej jaskini Kobry'), nl,
        nl.

opisz(dżungla) :- 
        write('Znajdujesz się w gęstej, ciemnej dżungli.'), nl,
        write('Na północy znajduje się mała polanka, która jest domem rodziny goryli.'), nl,
        nl.

opisz(polanka) :- 
        write('Zbliżasz się do sporej polanki,'), nl,
        write('na której znajdują się dwa goryle z rodu Pumba.'), nl,
        write('Potężny goryl Koko patrzy się na ciebie spokojnym wzrokiem.'), nl,
        write('Mały Bobo skacze radośnie.'), nl, nl,
        write('Na południu znajduje się mroczna dżungla.'), nl,
        write('Na wschodzie widzisz długą ścieżkę,'), nl,
        write('a na zachodzie zjawiskowy klasztor Tiu-Fiu.'), 
        nl.
   
opisz(klasztor) :- 
        write('Znajdujesz się w starożytnym budynku - sercu szkoły Tiu-Fiu.'), nl,
        write('Po środku stoi mistrz starożytnych sztuk walki Tiu-Fiu - Uebe.'), nl, nl,
        write('Na wschodzie znajduje się Polanka goryli,'), nl,
        write('a na północy "jaskinia próby".'), nl,
        nl.

opisz(jaskinia_próby) :- 
        write('Po wejściu do jaskini,'), nl,
        write('wrota zamykają się za tobą.'), nl,
        write('Po wielogodzinnej i ciężkiej tułaczce przez'), nl,
        write('długą i głęboką jaskinię próby,'), nl,
        write('odwodniony,'), nl,
        write('głodny i zmęczony,'), nl,
	write('docierasz do dziwnego,'), nl,
        write('ciemnego i oślizgłego pomieszczenia,'), nl,
        write('całego pokrytego kurzem,'), nl,
        write('pajęczynami,'), nl,
        write('szkieletami i starymi książkami.'), nl,
        write('Na fotelu zauważasz starego gnoma.'), nl,
        nl.

opisz(jaskinia_kobry) :- 
        żywy(pająk),
        write('Wchodzisz do ciemnej i przerażającej jaskini Kobry.'), nl,
        write('Po kilku minutach przemierzania,'), nl,
        write('zauważasz przerażającego,'), nl,
        write('wielkiego, włochatego pająka.'), nl,
        write('Lepiej stąd zmykaj!'), nl,
        nl.
        

opisz(jaskinia_kobry) :-
        \+żywy(pająk),
        write('Wchodzisz do ciemnej i przerażającej jaskini Kobry.'), nl,
        write('W jej głębi leży oślizgłe ciało pająka zabitego przez ciebie.'), nl, nl,
        write('Wyjście znajduje się na północy.'), nl,
        nl.


opisz(dziedziniec_fortu) :-
        write('Znajdujesz się przed wejściem fortu,'), nl,
        write('które jest po twojej wschodniej stronie.'), nl,
        write('Na zachodzie znajduje się ścieżka, z której przyszedłeś.'), nl,
        żywy(andrzej), (
                write('Podbiega do ciebie łotrzyk Andrzej i mówi:'), nl, nl,
                write(' " Czego tu szukasz?'), nl,
                write('   Czy życie ci nie miłe?'), nl,
                write('   Jeśli stąd nie pójdziesz,'), nl,
                write('   przerobimy cię na dywan! "'), nl,
                nl, !
        );
                write('Pod twoimi nogami leży ciało łotrzyka Andrzeja.'), nl,
                nl.

opisz(fort) :-
        \+zadania(zabiłeś_kłusowników),
        assert(zadania(zabiłeś_kłusowników)),
        nl,
        write('Znajdujesz się na dziedzińcu fortu - z każdej strony widzisz uzbrojonych po zęby kłusowników.'), nl,
        write('Na szczęście jesteś już pełnoprawnym wybrańcem i mistrzem sztuk walki Tiu-Fiu.'), nl,
        write('Teraz dopełnia się twoje przeznaczenie.'), nl,
        write('Kłusownicy otwierają ogień,'), nl,
        write('ty jednak skutecznie unikasz wszystkich ich strzałów,'), nl,
        write('w międzyczasie strzelając ze swojego pięknego Excalibra.'), nl,
        write('W mgnieniu oka wszystkich dziesięciu kłusowników pada na ziemię,'), nl,
        write('a ty nabierasz jeszcze większej ochoty na banany z dżungli.'), nl, nl,
        write('Na zachodzie znajduje się wyjście.'), nl.
        
opisz(fort) :-
        write('Znajdujesz się na dziedzińcu fortu kłusowników.'), nl,
        write('Otaczają cię ciała złych kłusowników.'), nl,
        write('Na zachodzie znajduje się wyjście.'), nl.


opisz(kamieniołom) :-
        \+zadania(zdobyles_excaliber),
        zadania(umiesz_tiu_fiu),
        assert(zadania(zdobyles_excaliber)),
        assert(przedmiot_w(excaliber, kamieniołom)),
        write('W kamieniołomie zdaje się, że nic nie ma,'), nl,
        write('ale w głębi odnalazłeś ornamentną złotą skrzynię.'), nl,
        write('Postanawiasz sprawdzić na niej swoje umiejętności Tiu-Fiu.'), nl,
        write('Skrzynia otwiera się,'), nl,
	write('ujawniając piękny pistolet "Excaliber"'), nl,
        write('Na południu znajduje się wyjście.'), nl, nl.

opisz(kamieniołom) :-
        zadania(zdobyles_excaliber),
        write('Stoisz po środku starego kamieniołomu,'), nl,
        write('w głębi stoi ornamentna złota skrzynia,'), nl,
        write('w której kiedyś był Excaliber.'), nl,
        write('Na południu znajduje się wyjście.'), nl, nl.    

opisz(kamieniołom) :-
        write('W kamieniołomie zdaje się, że nic nie ma,'), nl,
        write('ale w głębi odnalazłeś ornamentną złotą skrzynię.'), nl,
        write('Niestety nie masz niczego,'), nl,
        write('czym mógłbyś ją otworzyć.'), nl,
        write('Na południu znajduje się wyjście.'), nl, nl.


/* opis postaci */

opisz(gnom) :- 
        write('W starym forcie znowu wielka siła się zjawiła,'), nl,
        write('kłusowników kiść dywanów wiele z nas zrobiła.'), nl,
        write('Dnia takiego to mrocznego obudzi się w dżungli,'), nl,
        write('Przedstawiciel brudnej, strasznej i złej rasy ludzi.'), nl,
        write('Nie będzie to jednak postać zła, ani skalana,'), nl,
        write('Lecz reinkarnacja naszego starożytnego Banana.'), nl,
        write('Bananine - tak go zwać lud nasz prosty będzie,'), nl,
        write('Jego osiągnięcia znane będą światu wszędzie.'), nl,
        nl,
        write('Taka przepowiednia widnieje na starożytnych freskach,'), nl,
        write('w moim domu Ghfjg, w górze Hasdkh.'), nl, nl,
        write('Ale niestety,'), nl,
        write('przed każdym potencjalnym wybrańcem stoi test,'), nl,
        write('którego zawalenie wiąże się ze strasznymi konsekwencjami.'), nl,
        write('<gnom przystawia ci do czoła karabin AK-47>'), nl, nl,
        write('Jakie zwierzę chodzi rano na czterech nogach,'), nl,
        write('na dwóch w ciągu dnia i na trzech wieczorem?'), nl,
        read(Odp),
        (Odp='człowiek'; Odp='czlowiek'), (
                write('<Zaskoczony gnom odstawia AK-47 na bok>'), nl,
                write('Hmmmm....'), nl,
                write('Ciekawa odpowiedź...'), nl,
                write('Jeszcze nikt nie podał do tej pory sensownej odpowiedzi,'), nl,
                write('<wskazuje palcem na stos szkieletów>'), nl, nl,
                write('ale twoja faktycznie zdaje się trzymać kupy.'), nl,
                write('Uznajmy, że przeszedłeś tę próbę, człowieku.'), nl, nl,
                write('<Gnom uderza cię w głowę i tracisz przytomność>'), nl,
                write('<Po jakimś czasie budzisz się w klasztorze Tiu-Fiu>'), nl,
                assert(zadania(przeszedłeś_próbę)),
                teleport(klasztor)
        ); 
        write('Żaden z ciebie Bananine!'), nl,
        write('GIŃ!'), nl,
        trzymasz(zepsuty_karabin), (
                write('<W ostatnim momencie przypominasz sobie o karabinie od Bobo>'), nl,
                write('<Jednym ruchem wyciągasz karabin i przystawiasz go do głowy gnoma>'), nl, nl,
                write('Zaraz zaraz, skąd to masz?'), nl,
                write('To legendarny złoty karabin mojego dziadka!'), nl,
                write('Oddawaj to, i wynoś się'), nl, nl,
                retract(trzymasz(zepsuty_karabin)),
                write('<Gnom uderza cię w głowę i tracisz przytomność>'), nl,
                write('<Po jakimś czasie budzisz się w klasztorze Tiu-Fiu>'), nl,
                assert(zadania(przeszedłeś_próbę)),
                teleport(klasztor)
        );
        śmierć.

opisz(koko) :-
        \+zadania(porozmawiaj_z_uebe_od_koko), (
                write('Witaj podróżniku! '), nl,
                write('Niestety żyjemy w ciężkich czasach.'), nl,
                write('Nasza rodzina stoi w obliczu zagłady!'), nl,
                write('Źli kłusownicy polują na nas i robią z naszych skór dywany! '), nl,
                write('Jeśli tak dalej pójdzie, to wszyscy zginiemy!'), nl, nl,
                write('Czy możesz nam pomóc?'), nl,
                write('Jeżeli ci się uda, na pewno zostaniesz sowicie nagrodzony bananami'), nl,
                write('\ttak./nie.'), nl,
                read(Odp),
                Odp='tak', (
                        write('Och, dziękuję!'), nl,
                        write('Powiadomię Uebe, mistrza starożytnych sztuk walki Tiu-Fiu'), nl,
                        write('o twojej dobroduszności, a na pewno cię wesprze!'), nl,
                        write('Poszukaj go na zachodzie.'), nl,
                        assert(zadania(porozmawiaj_z_uebe_od_koko)), nl,
                        write('<dostałeś zadanie od Koko>'), nl
                ); 
                        write('A zatem wszyscy zginiemy!'), nl
        );
        \+zadania(zabiłeś_kłusowników),(
                nl,                        
                write('Czy porozmawiałeś już z Uebe?'), nl
        );
                nl,
                write('Oto nasz wybawca Bananine!'), nl.

opisz(uebe) :-
        \+zadania(porozmawiaj_z_uebe_od_koko),(
                nl,
                write('Ludzie nie mają czego szukać w tym świętym miejscu.'), nl,
                write('Żegnam.'), nl
        );
        \+zadania(wejdź_do_jaskini_próby),( /* nie otrzymano jeszcze zadania */
                nl,
                assert(zadania(wejdź_do_jaskini_próby)),
                write('Podobno chcesz nam pomóc... Hmmm...'), nl,
                write('Być może przepowiednia ziści się w twojej osobie?'), nl,
                write('W każdym razie, jeżeli twoja pomoc okaże się owocna,'), nl,
                write('nagrodzę cię dożywotnim zapasem bananów.'), nl, nl,
                write('Jeśli chcesz nauczyć się sztuki Tiu-Fiu,'), nl,
                write('musisz poprawnie przejść test w Jaskini Próby.'), nl,
                write('<otwiera wrota jaskini próby>'), nl,
                write('Nie martw się, to z pewnością bezpieczne.'), nl
        );
        \+zadania(przeszedłeś_próbę),(
                /* otrzymano zadanie wejścia do jaskini próby */
                nl,
                write('Wejdź do jaskini próby!'), nl,
                write('Przekonajmy się czy płynie w tobie krew Banana!'), nl
        );
        /* po przejściu próby */
        \+zadania(zaatakuj_uebe),(
                assert(zadania(zaatakuj_uebe)),
                write('Interesujące...'), nl,
                write('Jeśli pragniesz zostać moim uczniem i zgłębić tajniki Tiu-Fiu,'), nl,
                write('najpierw udowodnij swoją wartość.'), nl, nl,
                write('Musisz odzyskać mój portfel ze starożytnej jaskini Kobry.'), nl,
                write('Aby do niej dotrzeć, musisz skierować się na wschód.'), nl,
                write('Wiele lat temu, złe pająki z rodu Kobry ukradły mi go.'), nl,
                write('Jednak zanim pójdziesz - musisz nauczyć się zaklęcia "Potassium";'), nl,
                write('tylko wtedy pokonasz pająki z rodu Kobry, które gnieżdżą się w jaskini.'), nl, nl,
                write('<obsypuje cię potasem>'), nl, nl,
                write('Teraz, spróbuj rzucić na mnie zaklęcie Potassium! (zaatakuj Uebe)'), nl
        ); 
        /* logika otrzymania zadania odzyskania portfela zaimplementowana w atakuj(uebe)*/
        \+zadania(odzyskaj_portfel),(
                /* jeśli rozmawiasz z uebe zamiast go atakokwać*/
                write('Zaatakuj mnie zaklęciem Potassium!'), nl
        );

        \+zadania(umiesz_tiu_fiu),(
                \+trzymasz(portfel),(
                        write('Nie odzyskałeś jeszcze mojego portfela!'), nl,
                        write('Zmykaj na wschód!'), nl
                );
                /*trzymasz portfel */
                retract(trzymasz(portfel)),
                assert(zadania(umiesz_tiu_fiu)),
                write('Niesamowite!'), nl,
                write('Udało ci się!'), nl,
                write('Nareszcie mogę spłacić kredyt.'), nl,
                write('Teraz nauczę cię walczyć w stylu Tiu-Fiu.'), nl, nl,     
                write('<mija wiele miesięcy, a ty stajesz się coraz silniejszy...>'), nl, nl,
                write('Umiesz teraz sztukę walki Tiu-Fiu!'), nl,
                write('Jednak wiedz,'), nl,
                write('że sama umiejętność Tiu-Fiu nie pozwoli ci pokonać wszystkich kłusowników.'), nl,
                write('Musisz jeszcze odnaleźć mój stary pistolet Luger Parabellum - Excaliber.'), nl,
                write('On pozwoli ci pokonać złych zbrodniarzy.'), nl,
                write('... Powodzenia, przyjacielu.'), nl
        );
        \+zadania(zabiłeś_kłusowników),(
                write('Czy odnalazłeś już mój stary pistolet Luger Parabellum - Excaliber?'), nl,
                write('On pozwoli ci pokonać złych zbrodniarzy.'), nl,
                write('Bywaj!'), nl
        );
                write('Oto nasz wybawca Bananine!!'), nl,
                write('A oto twoja nagroda: dożywotni zapas bananów;'), nl,
                write('możesz do końca życia żyć w naszej rodzinie i cieszyć się naszymi bananami.'), nl,
                write('Pokój z tobą.'), nl, nl,
                write('<ZWYCIĘSTWO>'), nl, nl,
                zakończ.

opisz(bobo) :-
        trzymasz(banan),
        write('BANANA!!! DAJ BANANA!'), nl,
        write('\t tak./nie.'), nl,
        read(Odp),
        Odp='tak',
        retract(trzymasz(banan)),
        write('DOBRE! BANANA!'), nl,
        write('<ucieszony Bobo wskazuje na broń ukrytą w trawie>'), nl,
        assert(przedmiot_w(zepsuty_karabin, polanka)),
        wypisz_przedmioty_w(polanka).

opisz(bobo) :- 
        write('U! U! A! A! AAAA!!'), nl,
        write('BANANA!'), nl.

opisz(andrzej) :-
        żywy(andrzej),(
                write('Nie rozmawiam z takimi jak ty!'), nl,
                write('Wynoś się stąd!'), nl
        );
                write('Andrzej z jakiegoś zagadkowego powodu'), nl,
                write('nie rusza się, ani nie odzywa...'), nl.

opisz(pająk) :-
        żywy(pająk),(
                write('ASSHSHSHHSHSHHHHH!!!'), nl, nl
        );
                write('Pająk z jakiegoś zagadkowego powodu'), nl,
                write('nie rusza się, ani nie odzywa...'), nl.



/* ataki (implementacja) */

atakuj_impl(uebe) :-
        zadania(zaatakuj_uebe), 
        \+zadania(odzyskaj_portfel),(
                write('Dobrze, jesteś gotowy.'), nl,
                write('Skieruj się teraz na wschód i odzyskaj mój portfel.'), nl,
                assert(zadania(odzyskaj_portfel))
        );
        write('Jak śmiesz!?'), nl, nl,
        write('<Uebe zabija cię magicznym zaklęciem Edudu>'), nl, nl,
        śmierć.


atakuj_impl(bobo) :-
        write('"AAAAAAA!!!!" - Bobo umiera.'), nl,
        write('Zaskoczony Koko wyrywa ci ręce.'), nl, nl,
        write('<umierasz>'), nl, nl,
        śmierć.


atakuj_impl(koko) :-
        write('Koko patrzy na ciebie zaskoczony,'), nl,
        write('jednym szybkim ruchem wyrywa ci wszystkie kończyny.'), nl, nl,
        write('<umierasz>'), nl, nl,
        śmierć.

atakuj_impl(pająk) :-
        \+żywy(pająk),(
                write('Pająk nie może być bardziej martwy.'), nl
        );
        zadania(odzyskaj_portfel),(
                write('Rzucasz na pająka zaklęcie mistrza Uebe - Potassium.'), nl,
                write('Pająk momentalnie kurczy się do rozmiaru naparstka, a ty go rozdeptujesz.'), nl,
                write('Zauważasz, że z pająka wypadł portfel mistrza Uebe.'), nl,
                assert(przedmiot_w(portfel, jaskinia_kobry)),
                retract(żywy(pająk)),
                wypisz_przedmioty_w(jaskinia_kobry)
        );
        write('SSSDHHSHHSHSHSHHS'), nl, nl,
        write('<pająk z łatwością cię rozgniata na ścianie swoją wielką nogą>'), nl, nl,
        śmierć.


atakuj_impl(andrzej) :-
        \+żywy(andrzej),(
                write('Andrzej nie może być bardziej martwy.'), nl
        );
        zadania(odzyskaj_portfel),
        trzymasz(excaliber),(
                write('Zastrzeliłeś łotrzyka Andrzeja.'), nl,
                write('Możesz teraz wejść do fortu.'), nl,
                retract(żywy(andrzej))
        );
        write('Andrzej jednym pchnięciem kłusowniczego sztyletu '), nl,
        write('morduje cię i przerabia na dywan.'), nl, nl,
        śmierć.

atakuj_impl(_) :-
        write('HAHA, nie możesz mnie zabić.'), nl.

/* rozmowa */

rozmawiaj(Postac) :-
        jestem_w(Miejsce),
        postać_w(Postac, Miejsce),
        opisz(Postac),
        !, nl.

rozmawiaj(_) :-
        write('Nie ma takiej postaci.'), nl.

/* atak */

atakuj(X) :-
        jestem_w(Miejsce),
        postać_w(X, Miejsce),
        atakuj_impl(X),
        !, nl.

atakuj(_) :-
        write('Nie ma takiej postaci.'), nl.
