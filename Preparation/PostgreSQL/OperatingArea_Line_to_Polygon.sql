create table germany.berlin_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.berlin_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.berlin_oa;

create table germany.frankfurt_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.frankfurt_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.frankfurt_oa;

create table germany.hamburg_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.hamburg_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.hamburg_oa;

create table germany.muenchen_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.muenchen_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.muenchen_oa;

create table germany.rheinland_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.rheinland_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.rheinland_oa;

create table germany.stuttgart_oa_poly as
select ogc_fid, ST_MakePolygon(wkb_geometry) 
from germany.stuttgart_oa
where st_isclosed(wkb_geometry);
DROP TABLE germany.stuttgart_oa;

