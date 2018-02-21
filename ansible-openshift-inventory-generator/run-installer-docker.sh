docker run -t -u `id -u` \
    -v .ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z \
    -v inventory/static/lab_openshift_inventory:/tmp/inventory:Z \
    -e INVENTORY_FILE=/tmp/inventory \
    docker.io/openshift/origin-ansible:v3.7


    #-e PLAYBOOK_FILE=playbooks/deploy_cluster.yml \
    #-e OPTS="-v" \