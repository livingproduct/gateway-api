
ALTER TABLE "public"."accounts" ALTER COLUMN "activeCustomer" drop default;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."accounts" add column "activeCustomer" boolean
--  not null;

alter table "public"."flowActions" drop constraint "flowActions_accountId_fkey";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."flowActions" add column "accountId" uuid
--  not null;

alter table "public"."flowActions" alter column "accountId" drop not null;
alter table "public"."flowActions" add column "accountId" text;

alter table "public"."flows" drop constraint "flows_accountId_fkey";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."flows" add column "accountId" uuid
--  not null;

alter table "public"."flows" alter column "accountId" drop not null;
alter table "public"."flows" add column "accountId" text;

DROP TABLE "public"."accounts";
