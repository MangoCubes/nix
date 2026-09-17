{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, config, ... }:
    {
      home.packages = [
        (pkgs.wrapHelm pkgs.kubernetes-helm {
          plugins = with pkgs.kubernetes-helmPlugins; [
            helm-secrets
            helm-diff
            helm-s3
            helm-git
          ];
        })
        pkgs.flannel
      ];
      home.sessionVariables = {
        KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
      };
    };

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable traefik";
  };
}
