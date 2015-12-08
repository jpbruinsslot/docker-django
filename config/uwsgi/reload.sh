#!/usr/bin/env bash
kill -s SIGHUP $(cat /run/uwsgi/django.pid)
