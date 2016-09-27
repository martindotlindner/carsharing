DROP TABLE if exists germany.berlin_oa_poly;
create table germany.berlin_oa_poly as
select * 
from germany.berlin_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.berlin_oa;

DROP TABLE if exists germany.frankfurt_oa_poly;
create table germany.frankfurt_oa_poly as
select *
from germany.frankfurt_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.frankfurt_oa;

DROP TABLE if exists germany.hamburg_oa_poly;
create table germany.hamburg_oa_poly as
select *
from germany.hamburg_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.hamburg_oa;

DROP TABLE if exists germany.muenchen_oa_poly;
create table germany.muenchen_oa_poly as
select *
from germany.muenchen_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.muenchen_oa;

DROP TABLE if exists germany.rheinland_oa_poly;
create table germany.rheinland_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.rheinland_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.rheinland_oa;

DROP TABLE if exists germany.stuttgart_oa_poly;
create table germany.stuttgart_oa_poly as
select *
from germany.stuttgart_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.stuttgart_oa;
