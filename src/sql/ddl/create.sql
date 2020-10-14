
--TODO: create atm_trips and tp_trips automatically, using virtual tables
create table if not exists transactions_atm (
	"MACHINECOUNTER" text,
	"ACQ_DATE"	text,
	"ENTITAT"	text,
	"ACC_DATE"	text,
	"TVXCVAB"	text,
	"VLVZ"		text,
	"TVXCVAA"	text,
	"CARD"		text,
	"TOP"		text,
	"CIERRE_ID"	text,
	"TITLE_NAME"	text,
	"ATM_ID"	text,
	"TRAVEL_ID"	text,
	"LINE"		text,
	"VTMT"		text,
	"REGTYPE"	text,
	"TFC"		text,
	"VTMH2"		text,
	"VTMH1"		text,
	"TVXFV"		text,
	"TVXFVS"	text,
	"SUTYPE"	text,
	"IPADDRESS"	text,
	"OPERATOR_NAME"	text,
	"STOP"		text,
	"MACHINE_CODE"	text,
	"SQUANTITY"	text,
	"TVXCVIB"	text,
	"TVXCVIA"	text,
	"OPERATIONDATE"	text,
	"TVXSVB"	text,
	"TGNT"		text,
	"ATM"		text,
	"TVXSVA"	text,
	"TGGTXTB"	text,
	"TGGTXTA"	text,
	"PRECIO_VIAJE"	real,
	"FILENAME"	text,
	"TGGTXZB"	text,
	"TGGTXZA"	text,
	"REGVERSION"	text,
	"TTC"		text,
	"BLACKLIST"	text,
	"LOG_ID"	text PRIMARY KEY,
	"MUNICIPI"	text,
	"PERFIL"	text,
	"TGGTXS"	text,
	"ATM2"		text,
	"OPERATOR_ID"	text,
	"TGGTXM"	text,
	"TVT"		text,
	"TGGTXI"	text,
	"TGGTXE"	text,
	"TFXLVA"	integer,
	"TFXMZ"		integer,
	"REINTEGRO"	real,
	"TGGTXA"	text,
	"ACC_DATE2"	text,
	"SERRCODE"	text,
	"STATEID"	text
);

CREATE TABLE IF NOT EXISTS transactions_tp (
  "﻿CODE" TEXT,
  "MACHINECOUNTER" TEXT,
  "TERMINAL_TYPE" TEXT,
  "PRICE" TEXT,
  "INITSTOPCODE" TEXT,
  "IPADDRESS" TEXT,
  "LOCATIONCODE" TEXT,
  "OPERATIONDATE" TEXT,
  "MACHINE_CODE" TEXT,
  "ATM_NAME" TEXT,
  "ACC_DATE2" TEXT,
  "LOG_ID" TEXT PRIMARY KEY,
  "COMPANY_ID" TEXT,
  "OPERATOR_TICKETCODE" TEXT,
  "ATM_ID" TEXT,
  "LINE_NAME" TEXT,
  "ENDSTOPCODE" TEXT,
  "FILENAME" TEXT,
  "OPERATOR_NAME" TEXT,
  "ACC_DATE" TEXT,
  "REGVERSION" TEXT,
  "TITLE_NAME" TEXT
);

-- Import municipalities using virtual table/shape, thus we can control better table structures
-- TODO: Need to specify relative paths from the makefile
CREATE TABLE municipalities (id  integer primary key, name TEXT, label TEXT, pop_2018 integer, zone_id text);
SELECT AddGeometryColumn('municipalities', 'geom', 4326, 'MULTIPOLYGON', 'XY');
SELECT CreateSpatialIndex('municipalities', 'geom');
CREATE VIRTUAL TABLE vs_municipalities USING VirtualShape('res/gis/municipalities', 'UTF-8', 4326);
INSERT INTO municipalities(id, name, label, pop_2018, zone_id,geom) SELECT id, name, label, pop_2018, zone_id, geometry FROM vs_municipalities;
DROP TABLE IF EXISTS vs_municipalities;

-- Import stops
CREATE TABLE stops (id  integer primary key, name TEXT);
SELECT AddGeometryColumn('stops', 'geom', 4326, 'POINT', 'XY');
SELECT CreateSpatialIndex('stops', 'geom');
CREATE VIRTUAL TABLE vs_stops USING VirtualShape('res/gis/atm-interurban-stops', 'UTF-8', 4326);
INSERT INTO stops(id, name, geom) SELECT id, name, geometry FROM vs_stops;
DROP TABLE IF EXISTS vs_stops;

-- Import coastline
CREATE TABLE coastline (category TEXT);
SELECT AddGeometryColumn('coastline', 'geom', 4326, 'MULTILINESTRING', 'XY');
SELECT CreateSpatialIndex('coastline', 'geom');
CREATE VIRTUAL TABLE vs_coastline USING VirtualShape('res/gis/coastline', 'UTF-8', 4326);
INSERT INTO coastline(category, geom) SELECT category, geometry FROM vs_coastline;
DROP TABLE IF EXISTS vs_coastline;


