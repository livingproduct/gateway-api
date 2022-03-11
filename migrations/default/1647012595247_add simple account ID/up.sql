
CREATE TABLE "public"."accounts" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") , UNIQUE ("id"));
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_accounts_updated_at"
BEFORE UPDATE ON "public"."accounts"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_accounts_updated_at" ON "public"."accounts" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;

alter table "public"."flows" drop column "accountId" cascade;

alter table "public"."flows" add column "accountId" uuid
 not null;

alter table "public"."flows"
  add constraint "flows_accountId_fkey"
  foreign key ("accountId")
  references "public"."accounts"
  ("id") on update restrict on delete restrict;

alter table "public"."flowActions" drop column "accountId" cascade;

alter table "public"."flowActions" add column "accountId" uuid
 not null;

alter table "public"."flowActions"
  add constraint "flowActions_accountId_fkey"
  foreign key ("accountId")
  references "public"."accounts"
  ("id") on update restrict on delete restrict;

alter table "public"."accounts" add column "activeCustomer" boolean
 not null;

alter table "public"."accounts" alter column "activeCustomer" set default 'true';
