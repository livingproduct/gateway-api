
drop schema "public" cascade;

create schema "public";

CREATE TABLE "public"."actionClick" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "value" text NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."actionGoto" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "url" text NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."actionKeyboardType" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "value" text NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."actionScreenshot" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "fullscreen" boolean DEFAULT true, "tolerance" numeric DEFAULT 0, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."actionWaitForTime" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "milliseconds" numeric NOT NULL DEFAULT 3000, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."flowActions" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "flow" uuid NOT NULL, "embeddedFlowId" uuid, "gotoId" uuid, "keyboardTypeId" uuid, "waitForTimeId" uuid, "clickId" uuid, "screenshotId" uuid, PRIMARY KEY ("id") , FOREIGN KEY ("clickId") REFERENCES "public"."actionClick"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("gotoId") REFERENCES "public"."actionGoto"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("keyboardTypeId") REFERENCES "public"."actionKeyboardType"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("screenshotId") REFERENCES "public"."actionScreenshot"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("waitForTimeId") REFERENCES "public"."actionWaitForTime"("id") ON UPDATE restrict ON DELETE restrict);
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
CREATE TRIGGER "set_public_flowActions_updated_at"
BEFORE UPDATE ON "public"."flowActions"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_flowActions_updated_at" ON "public"."flowActions" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE "public"."flows" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "order" jsonb, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;

alter table "public"."flowActions"
  add constraint "flowActions_flow_fkey"
  foreign key ("flow")
  references "public"."flows"
  ("id") on update restrict on delete restrict;

alter table "public"."flowActions"
  add constraint "flowActions_embeddedFlowId_fkey"
  foreign key ("embeddedFlowId")
  references "public"."flows"
  ("id") on update restrict on delete restrict;

CREATE TABLE "public"."FlowState" ("value" text NOT NULL, PRIMARY KEY ("value") , UNIQUE ("value"));

alter table "public"."flows" add column "stateValue" text
 not null default 'Draft';

alter table "public"."flows"
  add constraint "flows_stateValue_fkey"
  foreign key ("stateValue")
  references "public"."FlowState"
  ("value") on update restrict on delete restrict;

INSERT INTO "public"."FlowState"("value") VALUES (E'Active');

INSERT INTO "public"."FlowState"("value") VALUES (E'Draft');

INSERT INTO "public"."FlowState"("value") VALUES (E'Archived');
