BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tournament" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" text NOT NULL,
    "nationId" text NOT NULL,
    "status" text NOT NULL,
    "eliminatedIn" text,
    "createdAt" timestamp without time zone NOT NULL,
    "finishedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "tournament_user_idx" ON "tournament" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tournament_fixture" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "tournamentId" uuid NOT NULL,
    "round" text NOT NULL,
    "groupName" text NOT NULL,
    "matchday" bigint NOT NULL,
    "kickoffUtc" timestamp without time zone NOT NULL,
    "homeNation" text NOT NULL,
    "awayNation" text NOT NULL,
    "venue" text NOT NULL,
    "homeScore" bigint,
    "awayScore" bigint,
    "playedByUser" boolean NOT NULL,
    "nonce" text
);

-- Indexes
CREATE INDEX "tournament_fixture_tournament_idx" ON "tournament_fixture" USING btree ("tournamentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" text NOT NULL,
    "displayName" text NOT NULL,
    "displayNameLower" text NOT NULL,
    "region" text,
    "favouriteNation" text,
    "createdAt" timestamp without time zone NOT NULL,
    "bannedUntil" timestamp without time zone,
    "termsAcceptedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_profile_user_idx" ON "user_profile" USING btree ("userId");
CREATE UNIQUE INDEX "user_profile_name_idx" ON "user_profile" USING btree ("displayNameLower");


--
-- MIGRATION VERSION FOR football
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('football', '20261003000626179', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003000626179', "timestamp" = now();

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
