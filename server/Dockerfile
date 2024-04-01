FROM postgres
COPY init.sql /docker-entrypoint-initdb.d/

# docker run -d --rm --env-file ./postgres.env --name postgres-db -p 8080:8080 postgres