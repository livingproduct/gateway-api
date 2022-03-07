
DELETE FROM "public"."FlowState" WHERE "value" = 'Archived';

DELETE FROM "public"."FlowState" WHERE "value" = 'Draft';

DELETE FROM "public"."FlowState" WHERE "value" = 'Active';

alter table "public"."flows" drop constraint "flows_stateValue_fkey";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."flows" add column "stateValue" text
--  not null default 'Draft';

DROP TABLE "public"."FlowState";

alter table "public"."flowActions" drop constraint "flowActions_embeddedFlowId_fkey";

alter table "public"."flowActions" drop constraint "flowActions_flow_fkey";

DROP TABLE "public"."flows";

DROP TABLE "public"."flowActions";

DROP TABLE "public"."actionWaitForTime";

DROP TABLE "public"."actionScreenshot";

DROP TABLE "public"."actionKeyboardType";

DROP TABLE "public"."actionGoto";

DROP TABLE "public"."actionClick";

drop schema "public" cascade;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- drop schema "public" cascade;
