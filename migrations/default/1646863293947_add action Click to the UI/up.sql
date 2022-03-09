
alter table "public"."flowActions" add column "accountId" text
 not null;

alter table "public"."actionClick" add column "accountId" text
 null;

alter table "public"."actionClick" alter column "accountId" set not null;
