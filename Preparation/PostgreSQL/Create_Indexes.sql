SET maintenance_work_mem = 2097151;
 
--for germany
--DROP INDEX if exists germany.idx_germany_routes_id;
DROP INDEX if exists germany.idx_germany_routes_provider;
DROP INDEX if exists germany.idx_germany_routes_timestampstart;
DROP INDEX if exists germany.idx_germany_routes_timestampend;

--CREATE INDEX idx_germany_routes_id ON germany.routes(id);
CREATE INDEX idx_germany_routes_provider ON germany.routes(provider);
CREATE INDEX idx_germany_routes_timestampstart ON germany.routes(timestampstart);
CREATE INDEX idx_germany_routes_timestampend ON germany.routes(timestampend);

--for berlin
/*
DROP INDEX if exists berlin.idx_berlin_routes_id;
DROP INDEX if exists berlin.idx_berlin_routes_provider;
DROP INDEX if exists berlin.idx_berlin_routes_timestampstart;
DROP INDEX if exists berlin.idx_berlin_routes_timestampend;

CREATE INDEX idx_berlin_routes_id ON berlin.routes(id);
CREATE INDEX idx_berlin_routes_provider ON berlin.routes(provider);
CREATE INDEX idx_berlin_routes_timestampstart ON berlin.routes(timestampstart);
CREATE INDEX idx_berlin_routes_timestampend ON berlin.routes(timestampend);
*/
