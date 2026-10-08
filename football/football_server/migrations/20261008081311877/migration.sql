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
-- ACTION ALTER TABLE
--
ALTER TABLE "friend_match" ADD COLUMN "mode" text NOT NULL DEFAULT 'match'::text;
ALTER TABLE "friend_match" ADD COLUMN "hostRatingDelta" bigint;
ALTER TABLE "friend_match" ADD COLUMN "guestRatingDelta" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "lobby" ADD COLUMN "mode" text NOT NULL DEFAULT 'match'::text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "penalty_kick" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "matchId" uuid NOT NULL,
    "seq" bigint NOT NULL,
    "shooterUserId" text NOT NULL,
    "shooterZone" bigint,
    "keeperZone" bigint,
    "outcome" text,
    "deadline" timestamp without time zone NOT NULL,
    "resolvedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "penalty_kick_match_seq_idx" ON "penalty_kick" USING btree ("matchId", "seq");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "queue_entry" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" text NOT NULL,
    "mode" text NOT NULL,
    "clientVersion" text NOT NULL,
    "rating" bigint NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL,
    "lastPollAt" timestamp without time zone NOT NULL,
    "lobbyId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "queue_entry_user_idx" ON "queue_entry" USING btree ("userId");
CREATE INDEX "queue_entry_mode_idx" ON "queue_entry" USING btree ("mode", "joinedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_result" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" text NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "imagePath" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "shared_result_user_idx" ON "shared_result" USING btree ("userId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_profile" ADD COLUMN "rating" bigint NOT NULL DEFAULT 1000;

--
-- MIGRATION VERSION FOR football
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('football', '20261008081311877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261008081311877', "timestamp" = now();

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
