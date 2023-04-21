# Authentication

Authentication is handled by [SuperTokens](https://supertokens.com/)

A trigger on the `ultri_auth.all_auth_recipe_users` table creates multipel records in the `izzup_api` schema.

## Member

A  record is created in `izzup_api.member` using the `all_auth_recipe_users.user_id` as the `member.uid`.
A `bigint` is auto-assigned as the primary key for relating to other tables.

## Account

The `member` has a single `personal` record in the `account` table.

Accounts are important becasue all services are provisioned to accounts, not members.

Members can create additional accounts as needed and will be an `owner` of the account.

Members can be added to accounts created by others as owners or other roles. 

`Permissions` are asserted against `roles` in `authorization`.

## Member Account

The member is linked as the `owner` of their personal account in the `member_account` table.



