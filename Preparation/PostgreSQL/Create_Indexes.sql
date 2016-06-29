SET maintenance_work_mem = 2097151;
DROP INDEX if exists world.idx_world_routes_id;
DROP INDEX if exists world.idx_world_routes_provider;
DROP INDEX if exists world.idx_world_routes_timestampstart;
DROP INDEX if exists world.idx_world_routes_timestampend;

CREATE INDEX idx_world_routes_id ON world.routes(id);
CREATE INDEX idx_world_routes_provider ON world.routes(provider);
CREATE INDEX idx_world_routes_timestampstart ON world.routes(timestampstart);
CREATE INDEX idx_world_routes_timestampend ON world.routes(timestampend);