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
CREATE TABLE "audit_log" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "actorId" text NOT NULL,
    "action" text NOT NULL,
    "target" text,
    "detail" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "friendship" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "requesterId" text NOT NULL,
    "addresseeId" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "friendship_pair_idx" ON "friendship" USING btree ("requesterId", "addresseeId");
CREATE INDEX "friendship_addressee_idx" ON "friendship" USING btree ("addresseeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "live_ops" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "maintenance" boolean NOT NULL,
    "message" text,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lobby_invite" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "lobbyId" uuid NOT NULL,
    "fromUserId" text NOT NULL,
    "toUserId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "lobby_invite_pair_idx" ON "lobby_invite" USING btree ("lobbyId", "toUserId");
CREATE INDEX "lobby_invite_to_idx" ON "lobby_invite" USING btree ("toUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lobby_message" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "lobbyId" uuid NOT NULL,
    "userId" text NOT NULL,
    "text" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "lobby_message_lobby_idx" ON "lobby_message" USING btree ("lobbyId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_report" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "reporterId" text NOT NULL,
    "targetId" text NOT NULL,
    "matchId" uuid,
    "reason" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "resolvedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_block" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" text NOT NULL,
    "blockedUserId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_block_pair_idx" ON "user_block" USING btree ("userId", "blockedUserId");


--
-- MIGRATION VERSION FOR football
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('football', '20261003010036000', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003010036000', "timestamp" = now();

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
