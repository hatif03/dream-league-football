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
CREATE TABLE "friend_match" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "lobbyId" uuid NOT NULL,
    "hostUserId" text,
    "guestUserId" text,
    "hostNation" text NOT NULL,
    "guestNation" text NOT NULL,
    "status" text NOT NULL,
    "hostClaim" text,
    "guestClaim" text,
    "hostGoals" bigint,
    "guestGoals" bigint,
    "endReason" text,
    "winnerUserId" text,
    "leaverUserId" text,
    "offer" text,
    "answer" text,
    "transport" text,
    "startedAt" timestamp without time zone NOT NULL,
    "firstClaimAt" timestamp without time zone,
    "endedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "friend_match_host_idx" ON "friend_match" USING btree ("hostUserId");
CREATE INDEX "friend_match_guest_idx" ON "friend_match" USING btree ("guestUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lobby" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "code" text NOT NULL,
    "hostUserId" text NOT NULL,
    "guestUserId" text,
    "hostNation" text,
    "guestNation" text,
    "hostReady" boolean NOT NULL,
    "guestReady" boolean NOT NULL,
    "status" text NOT NULL,
    "clientVersion" text NOT NULL,
    "matchId" uuid,
    "rematchLobbyId" uuid,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "lobby_code_idx" ON "lobby" USING btree ("code");
CREATE INDEX "lobby_host_idx" ON "lobby" USING btree ("hostUserId");
CREATE INDEX "lobby_guest_idx" ON "lobby" USING btree ("guestUserId");


--
-- MIGRATION VERSION FOR football
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('football', '20261003001917648', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003001917648', "timestamp" = now();

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
