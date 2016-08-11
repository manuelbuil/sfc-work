container_id=$(docker ps|grep functest|head -1|awk '{print $1}')

if [ -n $container_id ]; then
    docker exec -ti $(docker ps|grep functest|head -1|awk '{print $1}') bash
else
    echo "There is no Functest container running currently."
    docker ps
fi
