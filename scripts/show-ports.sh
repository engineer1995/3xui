#!/usr/bin/env bash
sudo ss -tulpn | grep -E 'x-ui|xray|8443|9834|2053|443|80' || true
