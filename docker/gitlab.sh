docker run --name gitlab-postgresql -itd --restart=always \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=XXXX' \
    --env 'DB_EXTENSION=pg_trgm,btree_gist' \
    --volume /data/docker/gitlab/postgresql:/var/lib/postgresql \
    sameersbn/postgresql:12-20200524

docker run --name gitlab-redis -itd --restart=always \
    --volume /data/docker/gitlab/redis:/data \
    redis:6.2.6

# generate a random string using pwgen -Bsv1 64 and assign it as the value of GITLAB_SECRETS_DB_KEY_BASE
docker run --name gitlab -itd --restart=always \
    --link gitlab-postgresql:postgresql --link gitlab-redis:redisio \
    --publish 10022:22 --publish 10080:80 \
    --env 'GITLAB_PORT=10080' --env 'GITLAB_SSH_PORT=10022' \
    --env 'GITLAB_HOST=XXXX' \
    --env 'GITLAB_SECRETS_DB_KEY_BASE=XXXX' \
    --env 'GITLAB_SECRETS_SECRET_KEY_BASE=XXXX' \
    --env 'GITLAB_SECRETS_OTP_KEY_BASE=XXXX' \
    --volume /data1/docker/gitlab/gitlab:/home/git/data \
    sameersbn/gitlab:16.3.4