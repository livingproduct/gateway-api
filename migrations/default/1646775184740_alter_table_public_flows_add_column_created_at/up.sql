alter table "public"."flows" add column "created_at" timestamptz
 null default now();
