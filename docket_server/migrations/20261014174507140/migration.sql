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
-- ACTION DROP TABLE
--
DROP TABLE "push_target" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "push_target" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ticketId" uuid NOT NULL,
    "endpoint" text NOT NULL,
    "p256dh" text NOT NULL,
    "authSecret" text NOT NULL,
    "linkCipher" text NOT NULL,
    "active" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "push_target_ticket_idx" ON "push_target" USING btree ("ticketId");

--
-- ACTION DROP TABLE
--
DROP TABLE "sms_target" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sms_target" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ticketId" uuid NOT NULL,
    "phoneCipher" text NOT NULL,
    "phoneLast4" text NOT NULL,
    "consentAt" timestamp without time zone NOT NULL,
    "linkCipher" text NOT NULL,
    "active" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "sms_target_ticket_idx" ON "sms_target" USING btree ("ticketId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "ticket" ADD COLUMN "transferTokenCipher" text;

--
-- MIGRATION VERSION FOR docket
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('docket', '20261014174507140', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014174507140', "timestamp" = now();

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
