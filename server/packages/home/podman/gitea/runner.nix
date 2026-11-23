{
  secrets,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  socket = "/run/user/1000/podman/podman.sock";
  ca = osConfig.security.pki.caBundle;
  runnerConfig = (pkgs.formats.yaml { }).generate "gitea-runner.yaml" {
    runner.labels = [ "ubuntu-latest:docker://docker.gitea.com/runner-images:ubuntu-latest" ];
    container = {
      docker_host = "unix://${socket}";
      options = "--volume ${ca}:/etc/ssl/certs/ca-certificates.crt:ro";
      valid_volumes = [ "${ca}" ];
    };
  };
in
{
  imports = [ secrets.server-main.home.gitea-runner ];
  custom.podman.containers.gitea-runner = {
    dependsOn = [ "gitea" ];
    image = "docker.gitea.com/act_runner:latest";
    mounts = [
      {
        inside = "/data";
        outside = "gitea-runner";
      }
      {
        inside = "/config.yaml";
        outside = "${runnerConfig}";
        readOnly = true;
      }
      {
        inside = socket;
        outside = socket;
      }
    ];
    environment = {
      "CONFIG_FILE" = "/config.yaml";
      "GITEA_INSTANCE_URL" = "https://git.int";
      "GITEA_RUNNER_NAME" = "runner";
    };
    environmentFile = [ config.sops.secrets.gitea-runner.path ];
  };
}
