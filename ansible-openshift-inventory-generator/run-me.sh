#!/bin/bash

ansible-playbook -i inventory/dynamic/digitalocean/do.py generate-lab-inventory.yml
