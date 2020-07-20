
DROP TABLE AU_OptionsDisponibles;
DROP TABLE AU_VentesOptions;
DROP TABLE AU_Options;
DROP TABLE AU_Ventes;
DROP TABLE AU_Clients;
DROP TABLE AU_Vehicules;
DROP TABLE AU_Modeles;
DROP TABLE AU_ModesFinancements;
DROP TABLE AU_Provinces;

-- Partie 1 déclaration des tables et insertion des données 
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy-mm-dd';
/*
declare
   c int;
begin
   select count(*) into c from user_tables where table_name = upper('AU_OptionsDisponibles');
   if c = 1 then
      execute immediate 'drop table AU_OptionsDisponibles';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_VentesOptions');
   if c = 1 then
      execute immediate 'drop table AU_VentesOptions';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Options');
   if c = 1 then
      execute immediate 'drop table AU_Options';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Ventes');
   if c = 1 then
      execute immediate 'drop table AU_Ventes';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Clients');
   if c = 1 then
      execute immediate 'drop table AU_Clients';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Vehicules');
   if c = 1 then
      execute immediate 'drop table AU_Vehicules';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Modeles');
   if c = 1 then
      execute immediate 'drop table AU_Modeles';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_ModesFinancements');
   if c = 1 then
      execute immediate 'drop table AU_ModesFinancements';
   end if;
   select count(*) into c from user_tables where table_name = upper('AU_Provinces');
   if c = 1 then
      execute immediate 'drop table AU_Provinces';
   end if;
      
end;
*/

-- Création  DE TABLES

CREATE TABLE AU_Modeles
(
	ModeCd varchar2(12) NOT NULL  CONSTRAINT PK_Modeles PRIMARY KEY ,
	ModCdDescFr varchar2(128) NOT NULL,
	ModCdDescEn varchar2(128) NOT NULL,
	TauxEscompteSaisonnier number(4,3) NOT NULL,
	DateFinEscompteSaisonnier date NOT NULL,
	TauxDescompteFidelite number(4,3) NOT NULL
    
);

CREATE TABLE AU_Vehicules
(
    NoSerieVehicule varchar2(11) NOT NULL  CONSTRAINT PK_Vehicule PRIMARY KEY ,
    NoImmatriculation varchar2(7) NOT NULL,
    ModeCd varchar2(12) NOT NULL,
    Couleur varchar2(25) NOT NULL,
    NbCylindres number(2) NOT NULL,
    NbChevaux number(3) NOT NULL,
    AnneeVehicule number(4) NOT NULL,
    PrixVehicule number(8,2) NOT NULL,
    
CONSTRAINT CK_NbChevaux CHECK (NbChevaux BETWEEN 100 AND 450 ),
    
CONSTRAINT CK_NbCylindre CHECK (NbCylindres IN('4','6','8','10','12')),

CONSTRAINT  check_AnneeVehicule
CHECK (AnneeVehicule BETWEEN 1950 AND 2020),

CONSTRAINT  check_NoSerieVehicule 
CHECK (REGEXP_LIKE(NoSerieVehicule,'MAZD[0-9]{7}')),
  
CONSTRAINT FK_Modeles FOREIGN KEY
(ModeCd) REFERENCES AU_Modeles (ModeCd)
/*
 CONSTRAINT  check_NoImmatriculation
CHECK (REGEXP_LIKE(NoImmatriculation,'')) 
*/
);
CREATE TABLE AU_Options
(
	OptionCd varchar2(12) CONSTRAINT PK_Options PRIMARY KEY NOT NULL,
	OptionCdDescFr varchar2(128) NOT NULL,
	OptionCdDescEn varchar2(128) NOT NULL
);
CREATE TABLE AU_OptionsDisponibles
(
OptionCd varchar2(12) NOT NULL ,
ModeCd varchar2(12) NOT NULL,
CONSTRAINT pk_OptionsDisponibles PRIMARY KEY (OptionCd,ModeCd),
OptionDisponible char(1) NOT NULL,
PrixUnitaireOption number(5,2) NOT NULL,

CONSTRAINT FK_Optioncd FOREIGN KEY
(OptionCd) REFERENCES AU_Options (OptionCd),
CONSTRAINT FK_Modelees FOREIGN KEY
(ModeCd) REFERENCES AU_Modeles (ModeCd)
);

CREATE TABLE AU_ModesFinancements
(
	ModeFinCd number(1)  CONSTRAINT PK_AU_ModesFinancements PRIMARY KEY NOT NULL,
	ModeFinCdDescFr varchar2(128) NOT NULL,
	ModeFinCdDescEn varchar2(128) NOT NULL
);

CREATE TABLE AU_Clients
(
	ClientID number(12) NOT NULL,
	Login varchar2(12) NOT NULL,
	ProvCd char(2) NOT NULL,
	SexeCd char(1) NOT NULL,
	ClientTpCd char(10) NOT NULL,
	LangCd char(2) NOT NULL,
	ClientNom varchar2(25) NOT NULL,
	ClientPrenom varchar2(25) NOT NULL,
	ClientSalutation varchar2(4) NOT NULL,
	ClientAdresse varchar2(128) NOT NULL,
	ClientVille varchar2(50) NOT NULL,
	ClientCdPostal char(7) NOT NULL,
	ClientPays varchar2(30) NOT NULL,
	ClientNoTel char(14) NOT NULL,
	ClientNoFax char(14),
	ClientEmail varchar2(40),
	ClientSiteInternet varchar2(100),
	IndicateurFidelite char(1) NOT NULL
   
);

CREATE TABLE AU_Provinces
(
	ProvCd char(2) CONSTRAINT PK_Provinces PRIMARY KEY NOT NULL,
	ProvCdDescFr varchar2(26) NOT NULL,
	ProvCdDescEn varchar2(26) NOT NULL,
	PcTaxeProv number(4,3) NOT NULL,
	PcTaxeFed number(4,3) NOT NULL
);

Alter TABLE AU_Clients
ADD(
CONSTRAINT PK_Clients PRIMARY KEY (ClientID),
CONSTRAINT FK_Provinces FOREIGN KEY (ProvCd)
REFERENCES AU_Provinces(ProvCd)
    
);
CREATE TABLE AU_Ventes
(
VenteID NUMBER CONSTRAINT PK_Ventes PRIMARY KEY NOT NULL ,
NoSerieVehicule VARCHAR2(11) NOT NULL,
ClientID NUMBER(12) NOT NULL  ,
ModeFinCd NUMBER NOT NULL  ,
EmplID NUMBER NOT NULL,
TauxEscompteSaisonnier NUMBER NOT NULL,
PrixSuggere NUMBER ,
PrixVenteVehicule NUMBER NOT NULL,
EscompteSaisonnier generated always AS (PrixVenteVehicule * TauxEscompteSaisonnier) ,
IndicateurFidelite char ,
TauxEscompteFidelite NUMBER ,
EscompteFidelite generated always AS (PrixVenteVehicule * TauxEscompteFidelite),
CoutTotalOption NUMBER ,

CoutVehiculeEscompte generated always AS(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite) ,

TotalVenteTaxable  generated always AS(PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption)) ,

TaxeFredCourante generated always AS(PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption) * 0.05),
TaxeProvCourante  generated always AS(PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption)*0.0975),
TotalTaxes generated always AS(PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption) * 0.05+ PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption)*0.0975),
GrandTotalVente generated always AS(PrixVenteVehicule+PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption) * 0.05+ PrixVenteVehicule-(PrixVenteVehicule*TauxEscompteSaisonnier+PrixVenteVehicule*TauxEscompteFidelite+CoutTotalOption)*0.0975)  ,
 CONSTRAINT FK_Vehicules FOREIGN KEY
(NoSerieVehicule) REFERENCES AU_Vehicules (NoSerieVehicule),

    CONSTRAINT FK_Client FOREIGN KEY
(ClientID) REFERENCES AU_Clients (ClientID),

    CONSTRAINT FK_AU_ModesFinancements FOREIGN KEY
(ModeFinCd) REFERENCES AU_ModesFinancements (ModeFinCd),
CONSTRAINT  check_NoSerieVehicule2 
CHECK (REGEXP_LIKE(NoSerieVehicule,'MAZD[0-9]{7}'))

);




CREATE TABLE AU_VentesOptions
(
    VenteID number NOT NULL,
    OptionCd varchar2(12) NOT NULL,
    ModeCd varchar2(12) NOT NULL,
    CONSTRAINT pk_VentesOptions PRIMARY KEY (VenteID,OptionCd, ModeCd),
    PrixUnitaireOption NUMBER NOT NULL,
    QteAchetee NUMBER(12),
    CoutOption NUMBER NOT NULL,
    
     CONSTRAINT FK_Vente FOREIGN KEY
(VenteID) REFERENCES AU_Ventes (VenteID),

    CONSTRAINT FK_Option FOREIGN KEY
(OptionCd) REFERENCES AU_Options (OptionCd),

    CONSTRAINT FK_Modele FOREIGN KEY
(ModeCd) REFERENCES AU_Modeles (ModeCd)

  
);

-- Création des séquences 
DROP SEQUENCE VenteID;
DROP SEQUENCE ClientID;



CREATE SEQUENCE VenteID
    INCREMENT BY 1
    START WITH 1
    
;
CREATE SEQUENCE ClientID
    INCREMENT BY 1
    START WITH 1
    
; 

-- Modification des tables 

-- Table clients
ALTER TABLE AU_Clients
ADD (
CONSTRAINT CK_SEXE CHECK (SexeCd  in ('M','F')),
CONSTRAINT CK_IdicateurFidelite CHECK (IndicateurFidelite in ('0','1')),
CONSTRAINT CK_Langue CHECK ( REGEXP_LIKE(LangCd ,'[a-z]{2}'))
/*
constraint check_ClientNoFax 
check (REGEXP_LIKE(ClientNoFax,'^\(?([0-9]{3})\)?[-.?]?([0-9]{3})[-.?]?([0-9]{4})$')),

constraint check_CodePostal 
check (REGEXP_LIKE(ClientCdPostal,'^[a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1} {0,1}[0-9]{1}[a-zA-Z]{1}[0-9]{1}'))
*/
);

-- Ajouter pk et fk 


-- Ajouter valeur par défault 
ALTER TABLE AU_Clients
MODIFY (
ClientVille varchar2(50) DEFAULT 'Québec',
ClientPays varchar2(30) DEFAULT 'Canada',
SexeCd char(1) DEFAULT 'M'

);

-- Modification AU_Ventes
ALTER TABLE AU_Ventes 
ADD (
DateVente date  DEFAULT SYSDATE ,
DateFinGarantie date
)
;
/*
AlTER TABLE AU_Ventes
modify DateFinGarantie generated always AS (EXTRACT(YEAR FROM sys )+5 );

*/
--Commentaire des tables
comment on table AU_Vehicules is 'La describtion d''un vehicule';
comment on table AU_Modeles is 'la model du vehicule';
comment on table AU_Ventes  is 'la procedure du ventes';
comment on table AU_Clients is 'le dossier d''un client';
comment on table AU_ModesFinancements is 'le mode de finance utiliser pour le ventes';
comment on table AU_Provinces is 'L''ensemble des provainces de les  clients';
comment on table AU_VentesOptions is 'La liste des options qui son en vehicule';
comment on table AU_OptionsDisponibles is 'La liste des choix/ des options disponible en entreprise ';
comment on table AU_Options is 'Liste des options';

--commentaire sur les champs du table vente
comment on column AU_Ventes.VenteID is 'L''id du table vente et son clé primaaire';
comment on column AU_Ventes.NoSerieVehicule is 'C''est le numero de serie d''une vehicule';
comment on column AU_Ventes.ModeFinCd is 'C''est la mode de financement';
comment on column AU_Ventes.EmplID is 'C''identifiant d''un employé ';
comment on column AU_Ventes.TauxEscompteSaisonnier is 'le taux d''une reduction pour saison';
comment on column AU_Ventes.DateVente is 'La date du vente d''une vehicule ';
comment on column AU_Ventes.DateFinGarantie is 'la date de fin du garantie';
comment on column AU_Ventes.PrixSuggere  is 'La première prix qu''on voit afficher sur la vehicule';
comment on column AU_Ventes.PrixVenteVehicule  is 'La prix finale du vehicule';
comment on column AU_Ventes.EscompteSaisonnier is 'Le rabbet du saison ';
comment on column AU_Ventes.CoutVehiculeEscompte is 'la reduction sur le cout du vehicule';
comment on column AU_Ventes.CoutTotalOption  is 'Le cout total sur un option ';
comment on column AU_Ventes.TaxeFredCourante  is 'Le taxe fédérale ajouter';
comment on column AU_Ventes.TaxeProvCourante  is 'Le taxe provinciale ajouter';
comment on column AU_Ventes.TotalTaxes  is 'Le taxe total ajouter  fédérale et provinciale';
comment on column AU_Ventes.GrandTotalVente  is 'La totale du vente inclue les frais et les taxes';

--commentaire sur les champs du table modele
comment on column Au_Modeles.ModeCd is 'Le clé primaire du table modele';
comment on column Au_Modeles.ModCdDescFr is 'la description d''un modele en françai';
comment on column Au_Modeles.ModCdDescEn is 'la description d''un modele en englai';
comment on column Au_Modeles.TauxEscompteSaisonnier is 'le taux d''une reduction pour saison';
comment on column Au_Modeles.DateFinEscompteSaisonnier is 'La date de fin d''une reduction ';
comment on column Au_Modeles.TauxDescompteFidelite  is 'Le taux des compte fidéle';

-- Données

INSERT INTO AU_Provinces VALUES ('QC', 'Québec', 'Quebec', 0.75, 0.05);
INSERT INTO AU_Provinces VALUES ('ON', 'Ontario', 'Ontario',  0, 0.13);
INSERT INTO AU_Provinces VALUES ('AB', 'Alberta', 'Alberta', 0, 0.05);
INSERT INTO AU_Provinces VALUES ('BC', 'Colombie-Britannique', 'British Columbia', 0.07, 0.05);
	
-- Insertion de données dans la table AU_Client

INSERT INTO AU_Modeles VALUES ('CX7','VUS compact', 'Compact crossover SUV', 0.10,'2020-01-04', 0);
INSERT INTO AU_Modeles VALUES ('CX5','VUS compact', 'Compact crossover SUV', 0.10,'2020-07-04', 0);
INSERT INTO AU_Modeles VALUES ('CX9','VUS', 'Full size SUV', 0.10, '2019-04-01', 0.02);
INSERT INTO AU_Modeles VALUES ('BT50','Pick-up', 'Pickup truck', 0, '2019-04-01', 0.02);
INSERT INTO AU_Modeles VALUES ('MX5','Roadster', 'Sports convertible', 0,'2018-01-08' ,0);

INSERT INTO AU_Vehicules VALUES ('MAZD0000001', '783 DJW', 'CX7', 'Rouge', 4, 244, 2007, 26935.76);
INSERT INTO AU_Vehicules VALUES ('MAZD8932321', '566 DKD', 'CX9', 'Noir', 6, 273, 2010, 39995.84);
INSERT INTO AU_Vehicules VALUES ('MAZD8239193', '654 NDS', 'BT50', 'Blanc', 8, 360, 2012, 36753.32);
INSERT INTO AU_Vehicules VALUES ('MAZD8982103', '666 DEV', 'MX5', 'Jaune', 4, 244, 2012, 32578.12);
INSERT INTO AU_Vehicules VALUES ('MAZD0912374', '111 SOS', 'CX7', 'Rouge', 4, 244, 2010, 27935.67);
INSERT INTO AU_Vehicules VALUES ('MAZD4896864', '258 DJS', 'CX7', 'Rouge', 4, 244, 2012, 28935.89);
INSERT INTO AU_Vehicules VALUES ('MAZD6556566', '689 OPP', 'CX5', 'Vert', 4, 162, 2012, 21589.74);
INSERT INTO AU_Vehicules VALUES ('MAZD5686687', '411 DFC', 'MX5', 'Vert', 4, 244, 2006, 33578.15);

INSERT INTO AU_Options VALUES ('CHROMEWHEELS', 'Roues chromÃ©s', 'Chrome wheels');
INSERT INTO AU_Options VALUES ('MP3PLAYER', 'Lecteur MP3', 'MP3 player');
INSERT INTO AU_Options VALUES ('LEATHERSEATS', 'SiÃ¨ges en cuir', 'Leather seats');

INSERT INTO AU_OptionsDisponibles VALUES ('CHROMEWHEELS', 'MX5', '1', 699.95);
INSERT INTO AU_OptionsDisponibles VALUES ('CHROMEWHEELS', 'CX5', '1', 399.95);
INSERT INTO AU_OptionsDisponibles VALUES ('CHROMEWHEELS', 'CX7', '0', 499.95);
INSERT INTO AU_OptionsDisponibles VALUES ('CHROMEWHEELS', 'CX9', '1', 499.95);
INSERT INTO AU_OptionsDisponibles VALUES ('MP3PLAYER', 'MX5', '1', 99.95);
INSERT INTO AU_OptionsDisponibles VALUES ('MP3PLAYER', 'CX5', '1', 99.95);
INSERT INTO AU_OptionsDisponibles VALUES ('MP3PLAYER', 'CX7', '1', 99.95);
INSERT INTO AU_OptionsDisponibles VALUES ('MP3PLAYER', 'CX9', '1', 99.95);
INSERT INTO AU_OptionsDisponibles VALUES ('MP3PLAYER', 'BT50', '1', 99.95);
INSERT INTO AU_OptionsDisponibles VALUES ('LEATHERSEATS', 'MX5', '1', 299.95);
INSERT INTO AU_OptionsDisponibles VALUES ('LEATHERSEATS', 'CX5', '0', 299.95);
INSERT INTO AU_OptionsDisponibles VALUES ('LEATHERSEATS', 'CX7', '0', 299.95);
INSERT INTO AU_OptionsDisponibles VALUES ('LEATHERSEATS', 'CX9', '0', 299.95);
INSERT INTO AU_OptionsDisponibles VALUES ('LEATHERSEATS', 'BT50', '0', 299.95);

INSERT INTO AU_ModesFinancements VALUES (1,'Comptant', 'Cash');
INSERT INTO AU_ModesFinancements VALUES (2,'Débit', 'Debit');
INSERT INTO AU_ModesFinancements VALUES (3,'Crédit', 'Credit');
INSERT INTO AU_ModesFinancements VALUES (4,'Crédit', 'Credit');
INSERT INTO AU_ModesFinancements VALUES (5,'Crédit', 'Credit');
INSERT INTO AU_ModesFinancements VALUES (6,'Crédit', 'Credit');
INSERT INTO AU_ModesFinancements VALUES (7,'Crédit', 'Credit');


-- Insertion des données 
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'sdc','QC','M','QC','En','Sogho','Sara','alo','22 avenu dep','Rimonski','g1d 2j4','Canada','(418)905-0798','(418)983-0934','sara@gmail.com','www.sara.qc.ca','0');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite) 
VALUES (ClientID.NEXTVAL,'rt','QC','F','QC','Fr','Marin','Julie','alo','29 avenu dep','Otawa','g1d 4j4','Canada','(418)905-0798','(418)983-0934','@gmail.com','www.joulie.ca','1');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'uyh','QC','M','QC
','Ar','Cheyakh','Meda','sel','29 avenu dep','Gatinau','s3k 8j4','Canada','(418)905-2345','(415)345-0934','meda@gmail.com','www.meda.mr','1');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'uyh','QC','M','QC
','Ar','Cheyakh','Meda','sel','29 avenu dep','Gatinau','s3k 8j4','Canada','(418)905-2345','(415)345-0934','meda@gmail.com','www.meda.mr','1');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'uyh','QC','M','QC
','Ar','Cheyakh','Meda','sel','29 avenu dep','Gatinau','s3k 8j4','Canada','(418)905-2345','(415)345-0934','meda@gmail.com','www.meda.mr','1');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'uyh','QC','M','QC
','Ar','Cheyakh','Meda','sel','29 avenu dep','Gatinau','s3k 8j4','Canada','(418)905-2345','(415)345-0934','meda@gmail.com','www.meda.mr','1');
INSERT INTO AU_Clients (ClientID,Login,ProvCd,SexeCd,ClientTpCd,LangCd,ClientNom,ClientPrenom,ClientSalutation,ClientAdresse,ClientVille,ClientCdPostal,ClientPays,ClientNoTel,ClientNoFax,ClientEmail,ClientSiteInternet,IndicateurFidelite)
VALUES (ClientID.NEXTVAL,'uyh','QC','M','QC
','Ar','Cheyakh','Meda','sel','29 avenu dep','Gatinau','s3k 8j4','Canada','(418)905-2345','(415)345-0934','meda@gmail.com','www.meda.mr','1');

-- Insertion des données dans la table AU_Ventes

INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8932321',1,1,5,0.05,3000,2000,1,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD5686687',2,2,9,0.50,3000,2000,0,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8982103',3,3,2,0.03,3000,2000,1,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8982103',4,4,2,0.03,3000,2000,1,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8982103',5,5,2,0.03,3000,2000,1,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8982103',6,6,2,0.03,3000,2000,1,0.02,300); 
INSERT INTO AU_Ventes (VenteID, NoSerieVehicule, ClientID, ModeFinCd, EmplID, TauxEscompteSaisonnier, PrixSuggere, PrixVenteVehicule, IndicateurFidelite, TauxEscompteFidelite, CoutTotalOption) VALUES (VenteID.NEXTVAL,'MAZD8982103',7,7,2,0.03,3000,2000,1,0.02,300); 


--Insertion de données dans la table AU_Ventes

INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (1,'MP3PLAYER','CX7',99.95,2,199.90);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (2,'CHROMEWHEELS','CX9',499.95,1,499.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (2,'LEATHERSEATS','CX9',299.95,1,299.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (3,'LEATHERSEATS','BT50',299.95,1,299.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (4,'LEATHERSEATS','MX5',299.95,1,299.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (4,'CHROMEWHEELS','MX5',699.95,1,699.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (7,'LEATHERSEATS','CX5',299.95,1,299.95);
INSERT INTO AU_VentesOptions (VenteID, OptionCd, ModeCd, PrixUnitaireOption,QteAchetee,CoutOption) VALUES (7,'MP3PLAYER','CX5',99.95,1,99.95);

