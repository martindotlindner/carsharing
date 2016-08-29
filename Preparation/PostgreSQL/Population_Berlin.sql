DROP TABLE if exists berlin.ewr2015;
CREATE TABLE berlin.ewr2015(
ZEIT character varying (20),
RAUMID character varying (20),
BEZ character varying (20),
PGR character varying (20),
BZR character varying (20),
PLR character varying (20),
STADTRAUM character varying (20),
E_E double precision,
E_EM double precision,
E_EW double precision,
E_E00_01 double precision,
E_E01_02 double precision,
E_E02_03 double precision,
E_E03_05 double precision,
E_E05_06 double precision,
E_E06_07 double precision,
E_E07_08 double precision,
E_E08_10 double precision,
E_E10_12 double precision,
E_E12_14 double precision,
E_E14_15 double precision,
E_E15_18 double precision,
E_E18_21 double precision,
E_E21_25 double precision,
E_E25_27 double precision,
E_E27_30 double precision,
E_E30_35 double precision,
E_E35_40 double precision,
E_E40_45 double precision,
E_E45_50 double precision,
E_E50_55 double precision,
E_E55_60 double precision,
E_E60_63 double precision,
E_E63_65 double precision,
E_E65_67 double precision,
E_E67_70 double precision,
E_E70_75 double precision,
E_E75_80 double precision,
E_E80_85 double precision,
E_E85_90 double precision,
E_E90_95 double precision, 
E_E95_110 double precision,
E_EU1 double precision,
E_E1U6 double precision,
E_E6U15 double precision,
E_E15U18 double precision,
E_E18U25 double precision, 
E_E25U55 double precision,
E_E55U65 double precision,
E_E65U80 double precision,
E_E80U110 double precision);

COPY berlin.ewr2015
FROM 'C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Berlin/Strukturdaten/EWR201512E_Matrix.csv'  DELIMITER ';' CSV HEADER;

-- Import shapefile with 'Planungsraum' from LOR (http://www.stadtentwicklung.berlin.de/planen/basisdaten_stadtentwicklung/lor/de/download.shtml)
SELECT * INTO berlin.ewr2015_plr FROM berlin.planungsraum JOIN berlin.ewr2015 ON berlin.planungsraum.schluessel = berlin.ewr2015.raumid;

--Calculate population density
ALTER TABLE berlin.ewr2015_plr DROP COLUMN if exists pop_density;
ALTER TABLE berlin.ewr2015_plr ADD COLUMN pop_density double precision;
UPDATE berlin.ewr2015_plr SET pop_density = e_e/(ST_Area(berlin.ewr2015_plr.geom)/1000000);

--Calculate peer group density
ALTER TABLE berlin.ewr2015_plr DROP COLUMN if exists pop_density_peergroup;
ALTER TABLE berlin.ewr2015_plr ADD COLUMN pop_density_peergroup double precision;
UPDATE berlin.ewr2015_plr SET pop_density_peergroup = (e_e25_27+e_e27_30+e_e30_35+e_e35_40+e_e40_45/(ST_Area(berlin.ewr2015_plr.geom)/1000000));

--Calculate percentage of peer group
ALTER TABLE berlin.ewr2015_plr DROP COLUMN if exists peergroup_percent;
ALTER TABLE berlin.ewr2015_plr ADD COLUMN peergroup_percent double precision;
UPDATE berlin.ewr2015_plr SET peergroup_percent = ((e_e25_27+e_e27_30+e_e30_35+e_e35_40+e_e40_45/e_e)*100);




	


