alter table "public"."actionClick" alter column "accountId" drop not null;
alter table "public"."actionClick" add column "accountId" text;
