{
  name,
  secretEnvPath,
  image ? "postgres:17",
  config,
}:
((import ./podman.nix) (
  let
    path = "${config.home.homeDirectory}/.podman/postgres-${name}";
  in
  {
    dependsOn = null;
    inherit image;
    name = "postgresql-${name}";
    activation = ''
      mkdir -p ${path}/scripts
      mkdir -p ${path}/data
    '';
    volumes = [
      "${path}/data:/var/lib/postgresql/data"
      "${path}/scripts:/var/lib/postgresql/scripts"
    ];
    environment = {
      DB_USERNAME = name;
      DB_DATABASE_NAME = "${name}-db";
    };
    environmentFile = [
      secretEnvPath
    ];
  }
))
# database:
#   container_name: immich_postgres
#   image:
#   environment:
#     POSTGRES_INITDB_ARGS: '--data-checksums'
#     # Uncomment the DB_STORAGE_TYPE: 'HDD' var if your database isn't stored on SSDs
#     # DB_STORAGE_TYPE: 'HDD'
#   volumes:
#     # Do not edit the next line. If you want to change the database storage location on your system, edit the value of DB_DATA_LOCATION in the .env file
#     - ${DB_DATA_LOCATION}:/var/lib/postgresql/data
#   shm_size: 128mb
#   restart: always
