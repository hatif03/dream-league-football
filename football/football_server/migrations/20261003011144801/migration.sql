BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "tournament_fixture" ADD COLUMN "matchNo" bigint;
ALTER TABLE "tournament_fixture" ADD COLUMN "homePens" bigint;
ALTER TABLE "tournament_fixture" ADD COLUMN "awayPens" bigint;
ALTER TABLE "tournament_fixture" ADD COLUMN "decidedBy" text;

--
-- MIGRATION VERSION FOR football
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('football', '20261003011144801', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003011144801', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
