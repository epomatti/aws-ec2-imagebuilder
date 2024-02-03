# EC2 Image Builder

This project created all of the resources for an Image Builder Pipeline with a **Tailscale** subnet router installation.

On top of subnet router [IP forwarding][3] settings, the image is also configured with Tailscale [performance best practices][4].

To see this image in use, check my other repository [epomatti/aws-rds-tailscale-vpn][2].

## Setup

Copy the `.auto.tfvars` file:

```sh
cp config/template.tfvars .auto.tfvars
```

To create the project resources:

```sh
terraform init
terraform apply -auto-approve
```

Login to the AWS Console and start the build process manually.

A launch template will be created to test the created image on EC2.

## Implementation

Recipe components:

- Linux update
- CloudWatch Agent
- Custom component for Tailscale with complete setup ([tailscale.yaml](./modules/imagebuilder/components/tailscale.yaml))
- Reboot

SSM agent is kept in the image to be used during launch. Vulnerability scan will be performed by the pipeline.

Additional information:

- Image Builder publishes managed or curated images which have higher update rates, but appear to be unavailable via other means. I've created this [thread][1] to learn more about it.
- EC2 build instances require internet access. This can be configured via NAT in the VPC, or enabling public IP addresses auto-assign.
- Make sure to make the installation completely noninteractive, for example with `DEBIAN_FRONTEND=noninteractive` for Debian-based distributions.

---

### Clean-up

Destroy the resources after use:

```sh
terraform destroy -auto-approve
```


[1]: https://repost.aws/questions/QUwGgIFpv8SuyY6uvxlWIcyg/where-to-find-ec2-image-builder-managed-images
[2]: https://github.com/epomatti/aws-rds-tailscale-vpn
[3]: https://tailscale.com/kb/1019/subnets
[4]: https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration
