import ./physical.digital-ocean.nix {
  dropletRegion = "nyc1";   # https://developers.digitalocean.com/documentation/v2/#list-all-regions
  dropletSize   = "512mb";  # https://developers.digitalocean.com/documentation/v2/#list-all-sizes
}
