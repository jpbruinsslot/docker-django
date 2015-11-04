#!/usr/bin/env bash
kill -s SIGHUP $(cat /run/nginx.pid)
