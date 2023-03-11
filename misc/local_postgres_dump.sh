#!/bin/bash
# pg_dump -h localhost -U postgres -d izzup -n izzup_api > ./misc/database/izzup_api_schema.sql 
# pg_dump -h localhost -U postgres -d izzup -n ultri_auth > ./misc/database/ulri_auth_schema.sql 
pg_dump -h localhost -U postgres -d izzup > ./misc/database/izzup_all.sql