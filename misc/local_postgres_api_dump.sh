#!/bin/bash
pg_dump -h localhost -U postgres -d izzup -n izzup_api > ./misc/database/izzup_schema.sql 