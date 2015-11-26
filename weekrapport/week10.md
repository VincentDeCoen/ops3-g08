# Voortgangsrapport week nn

* Groep: g08
* Datum: 27/11/2015

| Student  | Aanw. | Opmerking |
| :---     | :---  | :---      |
| Vincent De Coen |       |           |
| Ruben Piro |       |           |
| Robbe Van Daele |       |           |
| Birgit Croux |       |           |
| Josey De Smet |      |            |

## Wat heb je deze week gerealiseerd?

### Algemeen

[Afbeelding huidige toestand Kanban-bord(en) invoegen]

* ...
* ...

[Afbeelding teamoverzicht tijdregistratie onderverdeeld per deelopdracht]

### Vincent De Coen

* ...

[Afbeelding individueel rapport tijdregistratie]

### Ruben Piro

* ...

[Afbeelding individueel rapport tijdregistratie]

### Robbe Van Daele

* ...

[Afbeelding individueel rapport tijdregistratie]

### Birgit Croux

* ...

[Afbeelding individueel rapport tijdregistratie]

### Josey De Smet

* ...

[Afbeelding individueel rapport tijdregistratie]


## Wat plan je volgende week te doen?

### Algemeen
### Vincent De Coen
### Ruben Piro
### Robbe Van Daele
### Birgit Croux
### Josey De Smet

## Waar hebben jullie nog problemen mee?

Webserver met aparte database-server: "error establishing database connection"  

Remote verbinding met dezelfde credentials van op command line lukt, verbinden via php-testscript lukt ook.

        <?php
        $link = mysql_connect('192.168.56.59', 'wordpress_usr', '1OjejAfPod');
        if (!$link) {
        die('Could not connect: ' . mysql_error());
        }
        mysql_select_db('wordpress_db') or die ('No database found');
        echo 'Connected successfully';
        mysql_close($link);
        ?>

Credentials en db host in wp-config.php:  
* geprobeerd met variabelen uit de ansible-rol (op het ip van de db host na, exact dezelfde bestanden als in de lempstack, die wel werkt)
* geprobeerd met alle gegevens hard-coded

Telkens ook de browsercache gewist bij het opvragen van de homepage.


## Feedback technisch luik

### Algemeen

### Vincent De Coen
### Ruben Piro
### Robbe Van Daele
### Birgit Croux
### Josey De Smet

## Feedback analyseluik

### Algemeen

### Vincent De Coen
### Ruben Piro
### Robbe Van Daele
### Birgit Croux
### Josey De Smet
