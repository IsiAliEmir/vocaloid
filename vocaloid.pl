/* 
De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. 
De cada canción se conoce el nombre y la cantidad de minutos de duración.

Queremos reflejar entonces que:
    ● megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y también canta
      la canción foreverYoung que dura 5 minutos.
    ● hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
    ● gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
    ● seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.
    ● kaito no sabe cantar ninguna canción.
Tener en cuenta que puede haber canciones con el mismo nombre pero con diferentes duraciones.

a) Generar la base de conocimientos inicial. */

% canta(Cantante, Cancion(Duracion)).
canta(megurineLuka, cancion("nightFever", 4)).
canta(megurineLuka, cancion("foreverYoung", 5)).
canta(hatsuneMiku, cancion("tellYourWorld", 4)).
canta(gumi, cancion("foreverYoung", 4)).
canta(gumi, cancion("tellYourWorld", 5)).
canta(seeU, cancion("novemberRain", 6)).
canta(seeU, cancion("nightFever", 5)).
/*
?- canta(Vocaloid, cancion("nightFever", Duracion)). 
Vocaloid = megurineLuka,
Duracion = 4 ;
Vocaloid = seeU,
Duracion = 5.

?- canta(megurineLuka, cancion(Cancion, Duracion)).  
Cancion = "nightFever",
Duracion = 4 ;
Cancion = "foreverYoung",
Duracion = 5.

Definir los siguientes predicados que sean totalmente inversibles, a menos que se indique lo contrario.
    1. Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos,
    por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al
    menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15. */
/*
cantaMasDeDosCanciones(Vocaloid):-
    estaEnNuestraBase(Vocaloid),
    canta(Vocaloid, Cancion1),
    canta(Vocaloid, Cancion2),
    Cancion1 \= Cancion2.
*/
estaEnNuestraBase(Vocaloid):- canta(Vocaloid, _).

cantaMasDeDosCanciones(Vocaloid):-
    estaEnNuestraBase(Vocaloid),
    findall(Cancion, canta(Vocaloid, Cancion), CancionesQueCanta),
    length(CancionesQueCanta, CantCanciones),
    CantCanciones >= 2.
/*
?- cantaMasDeDosCanciones(Quien).
Quien = megurineLuka ;
Quien = gumi ;
Quien = seeU.
*/
duraMenosDe15(Vocaloid):-
    estaEnNuestraBase(Vocaloid),
    findall(Duracion, canta(Vocaloid, cancion(_, Duracion)), ListaDuraciones),
    sum_list(ListaDuraciones, DuracionTotal),
    DuracionTotal < 15.
/*
?- duraMenosDe15(Quien).
Quien = megurineLuka ;
Quien = hatsuneMiku ;
Quien = gumi ;
Quien = seeU.
*/
esNovedoso(Vocaloid):-
    cantaMasDeDosCanciones(Vocaloid),
    duraMenosDe15(Vocaloid).
/*
?- esNovedoso(Quien).
Quien = megurineLuka ;
Quien = gumi ;
Quien = seeU.
*/
/*  2. Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les
    gusta, es por eso que se pide saber si un cantante es acelerado, condición que se da cuando
    todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2. */

% Si todas sus canciones tienen duracion =< 4, significa que no tiene canciones con duracion > 4.
esAcelerado(Vocaloid):-
    estaEnNuestraBase(Vocaloid),
    not((canta(Vocaloid, cancion(_, Duracion)), Duracion > 4)).
/*
?- esAcelerado(Quien).
Quien = hatsuneMiku.
*/