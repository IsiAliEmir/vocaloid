%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

Definir los siguientes predicados para que sean totalmente inversibles:

1. Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos,
por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al
menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15. 
*/
estaEnNuestraBase(Vocaloid):- canta(Vocaloid, _).

cantaMasDeXCanciones(Vocaloid, X):-
    estaEnNuestraBase(Vocaloid),
    findall(Cancion, canta(Vocaloid, Cancion), CancionesQueCanta),
    length(CancionesQueCanta, CantCanciones),
    CantCanciones > X.
/*
?- cantaMasDeXCanciones(Quien, 1).
Quien = megurineLuka ;
Quien = gumi ;
Quien = seeU.
*/
duraMenosDeXMinutos(Vocaloid, X):-
    estaEnNuestraBase(Vocaloid),
    findall(Duracion, canta(Vocaloid, cancion(_, Duracion)), ListaDuraciones),
    sum_list(ListaDuraciones, DuracionTotal),
    DuracionTotal < X.
/*
?- duraMenosDeXMinutos(Quien, 15).
Quien = megurineLuka ;
Quien = hatsuneMiku ;
Quien = gumi ;
Quien = seeU.
*/
esNovedoso(Vocaloid):-
    cantaMasDeXCanciones(Vocaloid, 1), % "al menos 2" es lo mismo que "más de 1".
    duraMenosDeXMinutos(Vocaloid, 15).
/*
?- esNovedoso(Quien).
Quien = megurineLuka ;
Quien = gumi ;
Quien = seeU.

2. Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Además de los vocaloids, conocemos información acerca de varios conciertos que se darán en un
futuro no muy lejano. De cada concierto se sabe su nombre, el país donde se realizará, una cantidad
de fama y el tipo de concierto.
Hay tres tipos de conciertos:
    ● gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y
      además la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
    ● mediano sólo pide que la duración total de las canciones del cantante sea menor a una
      cantidad determinada.
    ● pequeño el único requisito es que alguna de las canciones dure más de una cantidad dada.

Queremos reflejar los siguientes conciertos:
    ● Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, le brinda 2000 de
      fama al vocaloid que pueda participar en él y pide que el vocaloid sepa más de 2 canciones y
      el tiempo mínimo de 6 minutos.
    ● Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y pide
      saber más de 3 canciones por cantante con un tiempo total mínimo de 10 minutos.
    ● Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama y exige
      un tiempo máximo total de 9 minutos.
    ● Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al
      vocaloid que participe en él, con la condición de que sepa una o más canciones de más de 4
      minutos.

1. Modelar los conciertos y agregar en la base de conocimientos todo lo necesario. */

% concierto(Nombre, Pais, Fama, Tipo).
concierto("Miku Expo", "Estados Unidos", 2000, tipo("gigante", 2, 6)). 
    % Requiere más de 2 canciones y duración total mayor o igual a 6 minutos.
concierto("Magical Mirai", "Japon", 3000, tipo("gigante", 3, 10)). 
    % Requiere más de 3 canciones y duración total mayor o igual a 10 minutos.
concierto("Vocalekt Visions", "Estados Unidos", 1000, tipo("mediano", 9)). 
    % Requiere duración total menor o igual a 9 minutos.
concierto("Miku Fest", "Argentina", 100, tipo("chico", 4)). 
    % Requiere alguna canción de más de 4 minutos.
/*
2. Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple
los requisitos del tipo de concierto. También sabemos que Hatsune Miku puede participar en
cualquier concierto. */

puedeParticipar(Vocaloid, concierto(_, _, _, tipo("gigante", XCanciones, XDuracion))):-
    estaEnNuestraBase(Vocaloid),
    cantaMasDeXCanciones(Vocaloid, XCanciones),
    not(duraMenosDeXMinutos(Vocaloid, XDuracion)). % >=X es lo mismo que not(<X).

puedeParticipar(Vocaloid, concierto(_, _, _, tipo("mediano", _, XDuracion))):-
    estaEnNuestraBase(Vocaloid),
    duraMenosDeXMinutos(Vocaloid, (XDuracion + 1)).

puedeParticipar(Vocaloid, concierto(_, _, _, tipo("chico", _, _))):-
    estaEnNuestraBase(Vocaloid),
    canta(Vocaloid, cancion(_, Duracion)),
    Duracion > 4.

puedeParticipar(hatsuneMiku, concierto(_, _, _, _)):-
    concierto(_, _, _, _).